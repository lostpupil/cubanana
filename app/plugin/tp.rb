module Cuba::Sugar
  module TypedParams
    def int(key)
      value = req[key]
      lambda { captures << value.to_i unless value.to_s.empty? }
    end
  end
end
