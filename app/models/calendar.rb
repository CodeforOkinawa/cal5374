class Calendar
  JA2EN_DAY_TABlE = %w(日 月 火 水 木 金 土).zip(%w(SU MO TU WE TH FR SA)).to_h

  include Mem

  def initialize(area_days)
    @area_days = area_days
  end

  def calname
    @area_days[AreaDays::AREA_COLUMN_NAME]
  end
  memoize :calname

  def to_s
    cal = Icalendar::Calendar.new
    cal.append_custom_property('X-WR-CALNAME;VALUE=TEXT', calname)
    cal.timezone do |t|
      t.tzid = tzid
      t.standard do |s|
        s.tzoffsetfrom = tzoffsetfrom
        s.tzoffsetto   = tzoffsetto
        s.tzname       = tzname
        s.dtstart      = dtstart
      end
    end
    events.each do |summary, days|
      cal.event do |e|
        e.dtstart     = Icalendar::Values::Date.new('20141201')
        e.summary     = summary
        e.rrule       = rrule(days)
      end
    end
    cal.publish
    cal.to_ical
  end

  private

  def events
    # FIXME: センターに対応したい
    @area_days.reject {|k, _|
      k == AreaDays::AREA_COLUMN_NAME || k == AreaDays::CENTER_COLUMN_NAME
    }
  end
  memoize :events

  def dtstart
    Time.at(0).utc.strftime("%Y%m%dT%H%M%S")
  end

  def tzid
    Time.zone.tzinfo.identifier
  end

  def tzname
    Time.zone.now.strftime("%Z")
  end

  def tzoffsetfrom
    Time.zone.now.strftime("%z")
  end

  alias tzoffsetto tzoffsetfrom

  def rrule(days)
    byday = days.split.map {|day|
      nth = day[1].try(:to_i).try(:nonzero?)
      "#{nth}#{JA2EN_DAY_TABlE[day[0]]}"
    }.join(?,)
    "FREQ=MONTHLY;BYDAY=#{byday}"
  end
end
