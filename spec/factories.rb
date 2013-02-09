FactoryGirl.define do

  factory :server do
    name "TF2 1"
    path "/home/tf2/tf2-1"
    ip "fakkelbrigade.eu"
    port "27015"
  end

  factory :user do
    uid "123456789"
    nickname "Terminator"
    name "Joe Sixpack"
    provider "steam"
  end

  factory :reservation do
    association :server
    association :user
    password "secret"
    rcon "supersecret"
    starts_at Time.now
    ends_at 2.hours.from_now
  end

  factory :group do
    name "Super Secret Servers"
  end

end
