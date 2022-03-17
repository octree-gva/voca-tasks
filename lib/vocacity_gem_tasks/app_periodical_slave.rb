module VocacityGemTasks
  class AppPeriodicalSave
    def initialize
      logger.info "⚙️ starts send to S3 (##{now})"
    end

    def end_of_month
      @end_of_month ||= DateTime.end_of_month
    end

    def end_of_year
      @end_of_year ||= DateTime.end_of_year
    end
  end
end
