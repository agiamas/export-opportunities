module Admin
  class ReportsController < BaseController
    include ActionController::Live

    Report = ImmutableStruct.new(:country, :months, :response_target)

    ImpactStatsReport = ImmutableStruct.new(:sent, :responded, :responded_with_feedback, :option_0, :option_1, :option_2, :option_3, :option_4)

    def show
      authorize :reports
      start_date = DateTime.new(params['impact_stats_date']['data(1i)'].to_i, params['impact_stats_date']['data(2i)'].to_i, params['impact_stats_date']['data(3i)'].to_i).in_time_zone('UTC').beginning_of_day
      @stats = calculate_impact_email_stats(start_date, start_date + 1.day) if params[:id] == 'impact_email'
    end

    def index
      authorize :reports

      if params[:commit]
        SendMonthlyReportToMatchingAdminUser.perform_async(current_editor, params)
        redirect_to admin_reports_path, notice: 'The requested Monthly Outcome against Targets by Country report has been emailed to you.'
      end
    end

    private

    def calculate_impact_email_stats(start_date = Time.zone.now.beginning_of_day - 1.day, end_date = Time.zone.now)
      isc = ImpactStatsCalculator.new.call(start_date, end_date)

      @impact_stats = ImpactStatsReport.new(
        sent: isc.sent,
        responded: isc.responded,
        responded_with_feedback: isc.responded_with_feedback,
        option_0: isc.option_0,
        option_1: isc.option_1,
        option_2: isc.option_2,
        option_3: isc.option_3,
        option_4: isc.option_4
      )
    end
  end
end
