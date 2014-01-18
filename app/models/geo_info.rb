class GeoInfo 
    attr_accessor :lat, :lng
    def initialize
                @location_manager ||= CLLocationManager.alloc.init.tap do |lm|
                        lm.desiredAccuracy = KCLLocationAccuracyBest
                        lm.distanceFilter = 10
                        lm.startMonitoringSignificantLocationChanges
                        lm.delegate = self
                end
    end

    def load
        self.lat = @location_manager.location.coordinate.latitude
        self.lng = @location_manager.location.coordinate.longitude
    end
end
