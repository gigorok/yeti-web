require 'spec_helper'

describe 'Index Gateway Groups' do
  include_context :login_as_admin

  include_examples :test_index_table_exist do
    before do
      @item = create(:gateway_group)
      visit gateway_groups_path
    end
  end
end
