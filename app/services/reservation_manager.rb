# frozen_string_literal: true
class ReservationManager

  attr_reader :reservation
  delegate :server, :to => :reservation, :prefix => false

  def initialize(reservation)
    @reservation = reservation
  end

  def start_reservation
    Rails.logger.info("Starting reservation #{reservation}")
    reservation.reservation_statuses.create!(:status => "Starting")
    manage_reservation(:start)
  end

  def end_reservation
    Rails.logger.info("Ending reservation #{reservation}")
    reservation.reservation_statuses.create!(:status => "Ending")
    manage_reservation(:end) unless reservation.ended?
  end

  def update_reservation
    Rails.logger.info("Updating reservation #{reservation}")
    manage_reservation(:update)
  end

  def manage_reservation(action)
    Rails.logger.info("Managing reservation #{reservation}. Action: #{action}")
    ReservationWorker.perform_async(reservation.id, action.to_s)
  end
end

