class ImportContactsJob < ApplicationJob
  queue_as :imports

  def perform(import_id, user_id)
    require 'csv'
    require 'active_merchant'

    @import = Import.find_by!(id: import_id)
    @import.start_process! if @import.may_start_process?

    csv = CSV.parse(@import.file.download, headers: true, encoding: 'UTF-8')
    column_pairing = @import.columns_pair
    success_contacts = []
    failed_contacts = []
    @import.log['logs'] ||= []
    
    csv.each_with_index do |row, index|
      cc_number = row[column_pairing['credit_card_number']]
      cc = ActiveMerchant::Billing::CreditCard.new(number: cc_number)

      new_contact = Contact.new(
        address: row[column_pairing['address']],
        birthdate: row[column_pairing['birthdate']],
        credit_card_number: cc_number,
        credit_card_network: cc.brand,
        last_4: cc.last_digits,
        email: row[column_pairing['email']],
        name: row[column_pairing['name']],
        phone: row[column_pairing['phone']],
        user_id: user_id,
        import_id: import_id
      )
      if new_contact.save
        @import.log['logs'] << {
          index_in_file: index,
          error: false,
          contact_info: row
        }
        success_contacts << new_contact
        Rails.logger.info("[ImportContactsJob] Contact imported! ID: #{new_contact.id}")
      else
        @import.log['logs'] << {
          index_in_file: index,
          error: true,
          contact_info: row,
          description: new_contact.errors.full_messages.to_sentence
        }
        failed_contacts << new_contact
        Rails.logger.error("[ImportContactsJob] Contact import failed! Index: #{index}")
        Rails.logger.error("[ImportContactsJob] #{new_contact.errors.full_messages}")
      end
    end
    
    if failed_contacts.any? && success_contacts.empty?
      @import.fail! if @import.may_fail?
    else
      @import.finish! if @import.may_finish?
    end
  end
end
