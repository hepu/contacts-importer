class ImportContactsService
  def initialize(import)
    @import = import
  end
  
  def call
    require 'csv'
    require 'active_merchant'
    
    raise 'File not found' unless @import.file.present?

    @import.start_process!

    success_contacts = []
    failed_contacts = []
    @import.log['logs'] ||= []
    @column_pairing = @import.columns_pair
    
    csv.each_with_index do |row, index|
      new_contact = build_contact(row)

      if new_contact.save
        @import.log['logs'] << { index_in_file: index, error: false, contact_info: row }
        success_contacts << new_contact
        Rails.logger.info("[ImportContactsJob] Contact imported! ID: #{new_contact.id} at: #{index}")
      else
        @import.log['logs'] << {
          index_in_file: index,
          error: true,
          contact_info: row,
          description: new_contact.errors.full_messages.to_sentence
        }
        failed_contacts << new_contact
        Rails.logger.error("[ImportContactsJob] Contact import failed! At: #{index}")
      end
    end
    
    @import.save!
    @import.notify_logs_change
    if failed_contacts.any? && success_contacts.empty?
      Rails.logger.info("[ImportContactsJob] Import failed!")
      @import.fail!
    else
      Rails.logger.info("[ImportContactsJob] Import finished!")
      @import.finish!
    end
  end
  
  private
  
  def csv
    CSV.parse(@import.file.download, headers: true, encoding: 'UTF-8')
  end
  
  def build_contact(row)
    cc_number = row[@column_pairing['credit_card_number']]
    cc = ActiveMerchant::Billing::CreditCard.new(number: cc_number)
    
    Contact.new(
      address: row[@column_pairing['address']],
      birthdate: row[@column_pairing['birthdate']],
      credit_card_number: cc_number,
      credit_card_network: cc.brand,
      last_4: cc.last_digits,
      email: row[@column_pairing['email']],
      name: row[@column_pairing['name']],
      phone: row[@column_pairing['phone']],
      user_id: @import.user_id,
      import_id: @import.id
    )
  end
end