# == Schema Information
#
# Table name: gateways
#
#  id                               :integer          not null, primary key
#  host                             :string
#  port                             :integer
#  src_rewrite_rule                 :string
#  dst_rewrite_rule                 :string
#  acd_limit                        :float            default(0.0), not null
#  asr_limit                        :float            default(0.0), not null
#  enabled                          :boolean          not null
#  name                             :string           not null
#  auth_enabled                     :boolean          default(FALSE), not null
#  auth_user                        :string
#  auth_password                    :string
#  term_outbound_proxy              :string
#  term_next_hop_for_replies        :boolean          default(FALSE), not null
#  term_use_outbound_proxy          :boolean          default(FALSE), not null
#  contractor_id                    :integer          not null
#  allow_termination                :boolean          default(TRUE), not null
#  allow_origination                :boolean          default(TRUE), not null
#  anonymize_sdp                    :boolean          default(TRUE), not null
#  proxy_media                      :boolean          default(FALSE), not null
#  transparent_seqno                :boolean          default(FALSE), not null
#  transparent_ssrc                 :boolean          default(FALSE), not null
#  sst_enabled                      :boolean          default(FALSE)
#  sst_minimum_timer                :integer          default(50), not null
#  sst_maximum_timer                :integer          default(50), not null
#  sst_accept501                    :boolean          default(TRUE), not null
#  session_refresh_method_id        :integer          default(3), not null
#  sst_session_expires              :integer          default(50)
#  term_force_outbound_proxy        :boolean          default(FALSE), not null
#  locked                           :boolean          default(FALSE), not null
#  codecs_payload_order             :string           default("")
#  codecs_prefer_transcoding_for    :string           default("")
#  src_rewrite_result               :string
#  dst_rewrite_result               :string
#  termination_capacity             :integer
#  term_next_hop                    :string
#  orig_next_hop                    :string
#  orig_append_headers_req          :string
#  term_append_headers_req          :string
#  dialog_nat_handling              :boolean          default(TRUE), not null
#  orig_force_outbound_proxy        :boolean          default(FALSE), not null
#  orig_use_outbound_proxy          :boolean          default(FALSE), not null
#  orig_outbound_proxy              :string
#  prefer_existing_codecs           :boolean          default(TRUE), not null
#  force_symmetric_rtp              :boolean          default(TRUE), not null
#  transparent_dialog_id            :boolean          default(FALSE), not null
#  sdp_alines_filter_type_id        :integer          default(0), not null
#  sdp_alines_filter_list           :string
#  gateway_group_id                 :integer
#  orig_disconnect_policy_id        :integer
#  term_disconnect_policy_id        :integer
#  diversion_policy_id              :integer          default(1), not null
#  diversion_rewrite_rule           :string
#  diversion_rewrite_result         :string
#  src_name_rewrite_rule            :string
#  src_name_rewrite_result          :string
#  priority                         :integer          default(100), not null
#  pop_id                           :integer
#  codec_group_id                   :integer          default(1), not null
#  single_codec_in_200ok            :boolean          default(FALSE), not null
#  ringing_timeout                  :integer
#  symmetric_rtp_nonstop            :boolean          default(FALSE), not null
#  symmetric_rtp_ignore_rtcp        :boolean          default(FALSE), not null
#  resolve_ruri                     :boolean          default(FALSE), not null
#  force_dtmf_relay                 :boolean          default(FALSE), not null
#  relay_options                    :boolean          default(FALSE), not null
#  rtp_ping                         :boolean          default(FALSE), not null
#  filter_noaudio_streams           :boolean          default(FALSE), not null
#  relay_reinvite                   :boolean          default(FALSE), not null
#  sdp_c_location_id                :integer          default(2), not null
#  auth_from_user                   :string
#  auth_from_domain                 :string
#  relay_hold                       :boolean          default(FALSE), not null
#  rtp_timeout                      :integer          default(30), not null
#  relay_prack                      :boolean          default(FALSE), not null
#  rtp_relay_timestamp_aligning     :boolean          default(FALSE), not null
#  allow_1xx_without_to_tag         :boolean          default(FALSE), not null
#  sip_timer_b                      :integer          default(8000), not null
#  dns_srv_failover_timer           :integer          default(2000), not null
#  rtp_force_relay_cn               :boolean          default(TRUE), not null
#  sensor_id                        :integer
#  sensor_level_id                  :integer          default(1), not null
#  dtmf_send_mode_id                :integer          default(1), not null
#  dtmf_receive_mode_id             :integer          default(1), not null
#  relay_update                     :boolean          default(FALSE), not null
#  suppress_early_media             :boolean          default(FALSE), not null
#  send_lnp_information             :boolean          default(FALSE), not null
#  short_calls_limit                :float            default(1.0), not null
#  origination_capacity             :integer
#  force_one_way_early_media        :boolean          default(FALSE), not null
#  radius_accounting_profile_id     :integer
#  transit_headers_from_origination :string
#  transit_headers_from_termination :string
#  external_id                      :integer
#  fake_180_timer                   :integer
#  sip_interface_name               :string
#  rtp_interface_name               :string
#  transport_protocol_id            :integer          default(1), not null
#  term_proxy_transport_protocol_id :integer          default(1), not null
#  orig_proxy_transport_protocol_id :integer          default(1), not null
#  rel100_mode_id                   :integer          default(4), not null
#  is_shared                        :boolean          default(FALSE), not null
#  max_30x_redirects                :integer          default(0), not null
#  max_transfers                    :integer          default(0), not null
#  incoming_auth_username           :string
#  incoming_auth_password           :string
#

require 'spec_helper'

describe Gateway, type: :model do

  shared_examples :validation_error_on_is_shared_change do
    let(:expected_error_message) {}

    let(:full_expected_error_message) do
      "Validation failed: Is shared #{expected_error_message}"
    end

    subject do
      record.update!(is_shared: false)
    end

    it 'raise error' do
      expect {
        subject
      }.to raise_error(ActiveRecord::RecordInvalid, full_expected_error_message)
    end
  end

  context 'uncheck is_shared' do

    let(:record) { create(:gateway, is_shared: true) }

    context 'when has linked CustomersAuth' do
      include_examples :validation_error_on_is_shared_change do
        before { create(:customers_auth, gateway: record) }
        let(:expected_error_message) do
          I18n.t('activerecord.errors.models.gateway.attributes.contractor.cant_be_changed_when_linked_to_customers_auth')
        end
      end
    end

    context 'when has linked Dialpeer' do
      include_examples :validation_error_on_is_shared_change do
        before { create(:dialpeer, gateway: record) }

        let(:expected_error_message) do
          I18n.t('activerecord.errors.models.gateway.attributes.contractor.cant_be_changed_when_linked_to_dialpeer')
        end
      end
    end

  end

  context 'scope :for_termination' do

    before do
      # in scope
      @record = create(:gateway, is_shared: false, allow_termination: true, name: 'b-gateway')
      @record_2 = create(:gateway, is_shared: true, allow_termination: true, name: 'a-gateway')
    end

    # out of scope
    before do
      # other vendor
      create(:gateway, allow_termination: true)
      # shared but not for termination
      create(:gateway, allow_termination: false, is_shared: true)
      # same vendor but not for termination
      create(:gateway, allow_termination: false, contractor: vendor)
    end

    let(:vendor) { @record.vendor }

    subject do
      described_class.for_termination(vendor.id)
    end

    it 'allow_termination is mandatory, then look for shared or vendors gateways, order by name' do
      expect(subject.pluck(:id)).to match_array([@record_2.id, @record.id])
    end

  end
end
