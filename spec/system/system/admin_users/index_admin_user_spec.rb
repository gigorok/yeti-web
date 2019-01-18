require 'spec_helper'

describe 'Index Admin Users' do
  include_context :login_as_admin

  include_examples :test_index_table_exist do
    before do
      @item = create(:admin_user)
      visit admin_users_path
    end
  end
end
