class ProgressSummaryController < ApplicationController
  def create
    progress_summary = ProgressSummary.new(
      url: params['progress_summary']['url'],
      level: params['progress_summary']['level']
    )
    render action: :show, locals: { progress_summary: progress_summary }
  end
end
