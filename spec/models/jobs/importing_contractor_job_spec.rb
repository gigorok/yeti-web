require 'spec_helper'
require 'shared_examples/shared_examples_for_importing_job'

describe 'Importing::Contractor => Contractor delayed_job' do
  it_behaves_like 'Jobs for importing data' do
    include_context :init_importing_delayed_job do
      include_context :init_importing_contractor
      let(:preview_class) { Importing::Contractor }
    end
  end
end
