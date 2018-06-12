require 'spec_helper'

describe Talkable::API::Share do
  describe "social" do
    let(:short_url_code) { 'SAMPLE' }
    let(:channel) { Talkable::API::Share::VIA_FACEBOOK }
    let(:response_hash) {
      {
        share: {
          id: 4452084,
          type: "SocialOfferShare",
          short_url: "https://www.talkable.com/x/hQ0SZb"
        },
        reward: {
          id: 24,
          reason: "shared",
          incentive_type: "discount_coupon",
          incentive_description: "shared coupon \"C1383-8321\" for $10 off",
          incentive_custom_description: nil,
          amount: nil,
          coupon_code: "C1383-8321",
          status: "Paid"
        }
      }
    }


    before do
      stub_request(:post, %r{.*api/v2/offers/SAMPLE/shares/social}).
        with(body: /.*"channel":"facebook".*/).
        to_return(body: '{
          "ok": true,
          "result": {
            "share": {
              "id": 4452084,
              "type": "SocialOfferShare",
              "short_url": "https://www.talkable.com/x/hQ0SZb"
            },
            "reward": {
              "id": 24,
              "reason": "shared",
              "incentive_type": "discount_coupon",
              "incentive_description": "shared coupon \"C1383-8321\" for $10 off",
              "incentive_custom_description": null,
              "amount": null,
              "coupon_code": "C1383-8321",
              "status": "Paid"
            }
          }
        }')
    end

    it ".create (deprecated)" do
      expect(Talkable::API::Share.create(short_url_code, channel: channel)).to eq(response_hash)

    end

    it ".social" do
      expect(Talkable::API::Share.social(short_url_code, channel: channel)).to eq(response_hash)
    end
  end

  describe "direct" do
    let(:short_url_code) { 'SAMPLE' }
    let(:channel) { Talkable::API::Share::SEND_EMAIL }
    let(:response_hash) {
      {
        recipients: {
          "friend1@example.com": {
            currently_sent: true,
            previously_sent: false,
            email_valid: true,
            self_referral: false,
            unsubscribed: false,
            blacklisted: false,
            meets_criteria: true,
            sharable: true
          },
          "friend2@example.com": {
            currently_sent: true,
            previously_sent: false,
            email_valid: true,
            self_referral: false,
            unsubscribed: false,
            blacklisted: false,
            meets_criteria: true,
            sharable: true
          }
        },
        reward: nil,
        stats: {
          currently_sent: 2,
          currently_not_sent: 0,
          previously_sent: 0,
          total_sent: 2,
          sent_limit_exceeded: false,
          left_emails: 20
        },
        success: true,
        validation_only: false
      }
    }

    before do
      stub_request(:post, %r{.*api/v2/offers/SAMPLE/shares.*}).
        to_return(body: '{
          "ok": true,
          "result": {
            "success": true,
            "validation_only": false,
            "stats": {
              "currently_sent": 2,
              "currently_not_sent": 0,
              "previously_sent": 0,
              "total_sent": 2,
              "sent_limit_exceeded": false,
              "left_emails": 20
            },
            "recipients": {
              "friend1@example.com": {
                "currently_sent": true,
                "previously_sent": false,
                "email_valid": true,
                "self_referral": false,
                "unsubscribed": false,
                "blacklisted": false,
                "meets_criteria": true,
                "sharable": true
              },
              "friend2@example.com": {
                "currently_sent": true,
                "previously_sent": false,
                "email_valid": true,
                "self_referral": false,
                "unsubscribed": false,
                "blacklisted": false,
                "meets_criteria": true,
                "sharable": true
              }
            },
            "reward": null
          }
        }')
    end

    it ".direct via email" do
      expect(Talkable::API::Share.direct(short_url_code,
        channel: channel,
        recipients: 'friend1@example.com,friend2@example.com',
        subject: 'Hello!',
        body: 'World!',
        reminder: false)).to eq(response_hash)
    end

    it ".direct fails when not email (for the time being)" do
      expect{Talkable::API::Share.direct(short_url_code,
        channel: 'random',
        recipients: 'Nathan',
        subject: 'Hello!',
        body: 'World!',
        reminder: false)}.to raise_error
    end
  end
end
