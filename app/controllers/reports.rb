module Controllers
  class Reports < Base
    binding.pry

    get "/:report_id" do
      if Faye::WebSocket.websocket?(request.env)
         handle_browser_connection(params[:report_id])
       else
         erb :"reports/index"
       end

    end

    def handle_browser_connection(report_id)
      ws = Faye::WebSocket.new(env)
      client_notifier = Services::ClientNotifier.new(report_id, ws).subscribe_to_research

      ws.on :close do |event|
        puts "Client disconnected!"
        client_notifier.terminate
        ws = nil
      end

      # Return async Rack response
      ws.rack_response
    end
    
  end
end