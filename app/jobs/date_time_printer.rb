class DateTimePrinter
  @queue = :low
  def self.perform(date_format, time_format)
    puts Time.now.strftime("Printed on #{date_format} at #{time_format}")
  end
end