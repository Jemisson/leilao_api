# frozen_string_literal: true

class BidsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'bids_channel'
  end

  def unsubscribed
    # Limpeza quando o canal for desconectado
  end
end
