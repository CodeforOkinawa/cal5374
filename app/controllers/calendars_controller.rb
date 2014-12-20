class CalendarsController < ApplicationController
  before_action :confirm_site_domain
  before_action :current_area_days, if: 'request.format == :ics'

  def show
    respond_to do |format|
      format.ics do
        filename = ERB::Util.url_encode("#{@calendar.calname}.ics")
        send_data(current_calendar.to_s, filename: filename)
      end
      format.html
    end
  end

  private

  def current_calendar
    @current_calendar ||= Calendar.new(current_area_days)
  end

  def current_area_days
    @current_area_days ||= AreaDays.new(params[:site]).find(params[:area]).to_h
  rescue AreaDays::NotFound => e
    render text: e.message
  end

  def confirm_site_domain
    valid_site_domain = Resolv::DNS::Name.create("5374.jp")
    site_domain = Resolv::DNS::Name.create(URI.parse(params[:site]).host) rescue nil

    return if site_domain.try(:subdomain_of?, valid_site_domain)

    render text: <<-NOTICE.strip_heredoc
      5374.jpのサブドメインのウェブサイトにのみ対応しています。
      指定されたウェブサイトのURL「#{params[:site]}」
    NOTICE
  end
end
