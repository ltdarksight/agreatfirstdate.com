Date::DATE_FORMATS[:default] = lambda { |date| I18n.l(date) }
DateTime::DATE_FORMATS[:default] = lambda { |datetime| I18n.l(datetime) }
Time::DATE_FORMATS[:default] = lambda { |datetime| I18n.l(datetime) }
