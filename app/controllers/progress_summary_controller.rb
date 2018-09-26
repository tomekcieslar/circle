class ProgressSummaryController < ApplicationController
  def create
    urls = params['progress_summary']['url'].split(/[\s,]+/)
    progress_summaries = []
    urls.each do |single_url|
      progress_summaries << ProgressSummary.new(
        url: single_url.strip,
        level: params['progress_summary']['level']
      )
    end
    render action: :show, locals: { progress_summaries: progress_summaries }
  end
end
