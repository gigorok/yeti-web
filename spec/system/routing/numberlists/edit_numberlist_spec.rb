# frozen_string_literal: true

require 'spec_helper'

describe 'Edit Numberlist' do
  include_context :login_as_admin

  context 'unset "Tag action value"' do
    include_examples :test_unset_tag_action_value,
                     controller_name: :numberlists,
                     factory: :numberlist
  end
end
