require 'rails_helper'

RSpec.describe TestJob, type: :job do
  it 'runs successfully' do
    expect {
      TestJob.perform_later("Hello RSpec")
    }.to have_enqueued_job(TestJob).with("Hello RSpec")
  end
end
