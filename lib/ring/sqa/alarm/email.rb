require 'net/smtp'

module Ring
class SQA
class Alarm

  class Email
    SERVER  = 'localhost'
    LIST_ID = 'ring-sqa <sqa.ring.nlnog.net>'

    def send opts
      short, long = opts[:short], opts[:long]
      @from     = CFG.email.from
      @to       = [CFG.email.to].flatten
      prefix    = CFG.email.prefix? ? CFG.email.prefix : ''
      @list_id  = CFG.email.list_id? ? CFG.email.list_id : LIST_ID
      @subject  = prefix + short
      @reply_to = CFG.email.reply_to? ? CFG.email.reply_to : @from
      send_email compose_email(long)
    rescue => error
      Log.error "Email raised '#{error.class}' with message '#{error.message}'"
    end

    private

    def compose_email body
      mail = []
      mail << 'From: '     + @from
      mail << 'To: '       + @to.join(', ')
      mail << 'Reply-To: ' + @reply_to
      mail << 'Subject: '  + @subject
      mail << 'List-Id: '  + @list_id
      mail << 'X-Mailer: ' + 'ring-sqa'
      mail << '' << body
      mail.join("\n")
    end

    def send_email email
      Net::SMTP.start('localhost') do |smtp|
        smtp.send_message email, @from, @to
      end
    end
  end

end
end
end
