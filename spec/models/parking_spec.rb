require 'rails_helper'

RSpec.describe Parking, type: :model do
  before do
    # 把每个测试都会用到的 @time 提取出来，这个 before 区块会在这个 describe 内的所有测试前执行
    @time = Time.new(2017,3, 27, 8, 0, 0) # 固定一个时间比 Time.now 更好，这样每次跑测试才能确保一样的结果
  end

  # context "validation" do
  #   describe ".validate_end_at_with_amount"do
  #     it "is invalid without amount" do
  #       parking = Parking.new( parking_type: "guest",
  #                              start_at:     Time.now - 6.hours,
  #                              end_at:       Time.now)
  #       expect( parking).to_not be_valid
  #     end
  #
  #     it "is invalid without end_at" do
  #       parking = Parking.new( parking_type: "guest",
  #                              start_at:     Time.now - 6.hours,
  #                              amount:       999)
  #       expect( parking).to_not be_valid
  #     end
  #   end
  # end

  context "guest" do
    before do
       # 把每个测试都会用到的 @parking 提取出来，这个 before 区块会在这个 context 内的所有测试前执行
       @parking = Parking.new( :parking_type => "guest", :user => @user, :start_at => @time )
     end

    describe ".calculate_amount" do
      it "30 minutes should be ¥2" do
        @parking.end_at = @time +  30.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "60 minutes should be ¥2" do
        @parking.end_at = @time +  60.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "61 minutes should be ¥3" do
        @parking.end_at = @time +  61.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)
      end

      it "90 minutes should be ¥3" do
        @parking.end_at = @time +  90.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)
      end

      it "120 minutes should be ¥4" do
        @parking.end_at = @time +  120.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(400)
      end
    end
  end

  context "short-term" do
     before do
       # 把每个测试都会用到的 @user 和 @parking 提取出来
       @user = User.create( :email => "test@example.com", :password => "123455678")
       @parking = Parking.new( :parking_type => "short-term", :user => @user, :start_at => @time )
     end

    it "30 minutes should be ¥2" do
      @parking.end_at = @time + 30.minutes
      @parking.calculate_amount
      expect(@parking.amount).to eq(200)
    end

    it "60 minutes should be ¥2" do
      @parking.end_at = @time + 60.minutes
      @parking.calculate_amount
      expect(@parking.amount).to eq(200)
    end

    it "61 minutes should be ¥2.5" do
      @parking.end_at = @time + 61.minutes
      @parking.calculate_amount
      expect(@parking.amount).to eq(250)
    end

    it "90 minutes should be ¥2.5" do
      @parking.end_at = @time + 90.minutes
      @parking.calculate_amount
      expect(@parking.amount).to eq(250)
    end

    it "120 minutes should be ¥3" do
      @parking.end_at = @time + 120.minutes
      @parking.calculate_amount
      expect(@parking.amount).to eq(300)
    end
  end

  context "long-term" do
     before do
       @user = User.create( :email => "test@example.com", :password => "123455678")
       @parking = Parking.new( :parking_type => "long-term", :user => @user, :start_at => @time )
     end

    it "6 hours should be ¥12" do
      @parking.end_at = @time + 6.hours
      @parking.calculate_amount
      expect(@parking.amount).to eq(1200)
    end

    it "7 hours should be ¥16" do
      @parking.end_at = @time + 7.hours
      @parking.calculate_amount
      expect(@parking.amount).to eq(1600)
    end

    it "24 hours should be ¥16" do
      @parking.end_at = @time + 24.hours
      @parking.calculate_amount
      expect(@parking.amount).to eq(1600)
    end

    it "25 hours should be ¥32" do
      @parking.end_at = @time + 25.hours
      @parking.calculate_amount
      expect(@parking.amount).to eq(3200)
    end

    it "49 hours should be ¥48" do
      @parking.end_at = @time + 49.hours
      @parking.calculate_amount
      expect(@parking.amount).to eq(4800)
    end
  end
end
