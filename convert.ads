package Convert with SPARK_Mode is

   Miles_Per_Hour_To_Meters_Per_Second : constant Long_Float := 0.44704;

   Meters_Per_Second_To_Miles_Per_Hour : constant Long_Float := 2.23694;

   --  /*! \brief Convert From MetersPerSecond To MilesPerHour  */
   Meters_Per_Second_To_Knots : constant Long_Float := 1.94384;

   --  /*! \brief Convert From MetersPerSecond To MilesPerHour  */
   Knots_To_Meters_Per_Second : constant Long_Float := 0.514444;

   --  /*! \brief Convert From Meters To Feet  */
   Meters_To_Feet : constant Long_Float := 3.280839895;

   --  /*! \brief Convert From Feet To Meters  */
   Feet_To_Meters : constant Long_Float := 0.3048;

   --  /*! \brief Convert From Degrees To Radians  */
   Degrees_To_Radians : constant Long_Float := 0.01745329251994;

   --  /*! \brief Convert From Radians To Degrees  */
   Radians_To_Degrees : constant Long_Float := 57.29577951308232;

   --  /*! \brief Convert PI  */
   Pi : constant Long_Float := 3.14159265359;

   --  /*! \brief Convert PI/2.0  */
   Pi_O2 : constant Long_Float := Pi / 2.0;

   --  /*! \brief Convert 3.0*PI/2.0  */
   Three_Pi_O2 : constant Long_Float := 3.0 * Pi_O2;

   --  /*! \brief Convert PI/8.0  */
   Pi_O8 : constant Long_Float := Pi / 8.0;

   --  /*! \brief Convert PI/10.0  */
   Pi_O10 : constant Long_Float := Pi / 10.0;

   --  /*! \brief Convert PI/18.0  */
   Pi_O18 : constant Long_Float := Pi / 18.0;

   --  /*! \brief Convert 2*PI  */
   Two_Pi : constant Long_Float := 2.0 * Pi;

   --  /*! \brief Gravitational Acceleration Ft/Sec2 */
   Gravity_Fp_S2 : constant Long_Float := 32.174;  --  // Ft/Sec^2

   --  /*! \brief Gravitational Acceleration M/Sec^2 */
   Gravity_Mps2 : constant Long_Float := 9.80665;   --  // M/Sec^2

   subtype RAD_Angle is Long_Float range -Two_Pi .. Two_Pi;
   subtype DEG_Angle is Long_Float range -360.00 .. 360.00;
   subtype RAD_Angle_Float is Float range -Float(Two_Pi) .. Float(Two_Pi);
   subtype DEG_Angle_Float is Float range -360.00 .. 360.00;

   --  /*! \brief Convert From Degrees To Radians  */
   function To_Radians (Degrees : DEG_Angle) return RAD_Angle is (Degrees * Degrees_To_Radians);

   --  /*! \brief Convert From Radians To Degrees  */
   function To_Degrees (Radians : RAD_Angle) return DEG_Angle;
   
   Earth_Circonference_M  : constant Long_Float := 40080000.0;
   Earth_Circonference_FT : constant Long_Float := Earth_Circonference_M * Feet_To_Meters;
   subtype Earth_Coordonate_M  is Long_Float range  - Earth_Circonference_M  .. Earth_Circonference_M;
   subtype Earth_Coordonate_FT is Long_Float range  - Earth_Circonference_FT .. Earth_Circonference_FT;
   
   subtype RAD_Latitude is RAD_Angle range - Pi_O2 .. Pi_O2;
   subtype DEG_Latitude is DEG_Angle range - 90.0  .. 90.0;
   
   function RAD_Angle_To_Latitude_Projection (Radian : RAD_Angle) return RAD_Latitude is 
     (if    Radian >  Pi_O2 then ( Pi - Radian)
      elsif Radian < -Pi_O2 then (-Pi - Radian)
      else  Radian);
   function DEG_Angle_To_Latitude_Projection (Degrees : DEG_Angle) return DEG_Latitude is 
     (if    Degrees >  90 then ( 180 - Degrees)
      elsif Degrees < -90 then (-180 - Degrees)
      else  Degrees);
                                                                                            
   
   function Latitude_To_Radians (Degrees : DEG_Latitude) return RAD_Latitude is (Degrees * Degrees_To_Radians);
   
   function Latitude_To_Degrees (Radians : RAD_Latitude) return DEG_Latitude;
   
   function To_Ft_Coordonate ( M_Coordonate : Earth_Coordonate_M)  return Earth_Coordonate_FT is
     (M_Coordonate * Feet_To_Meters);
   function To_M_Coordonate ( FT_Coordonate : Earth_Coordonate_FT) return Earth_Coordonate_M;
 
   
   type En_Relational_Operators is (EnGreater,
                                    EnGreaterEqual,
                                    EnLess,
                                    EnLessEqual,
                                    EnEqual,
                                    EnTotalRelationalOperators);

   function Compare (Argument1    : Long_Float;
                     Argument2    : Long_Float;
                     Rel_Operator : En_Relational_Operators;
                     Epsilon      : Long_Float := (10.0**(-9))) return Boolean;

   function Compare (Argument1    : Float;
                     Argument2    : Float;
                     Rel_Operator : En_Relational_Operators;
                     Epsilon      : Float := (10.0**(-9))) return Boolean;

   function IRound (Number : Long_Float) return Integer
   is (Integer (Number+0.5))
     with Pre => Number in Long_Float'First + 100.0 .. Long_Float'Last - 100.0;

   --
   --     --Static Void DRound(Double DNumber,Const Double DDecimalPlace)
   --     function DRound(Number, Decimal_Place  : Long_Float) return Long_Float
   --
   --     is (if Decimal_Place = 0.0 then
   --            Long_Float'Floor(Number + 0.5)
   --         elsif  Decimal_Place > 0.0 then
   --            Long_Float'Floor(Long_Float'Floor(Number)/Decimal_Place) * Decimal_Place
   --         else Long_Float'Floor(Number) +
   --           Long_Float'Floor((Number - Long_Float'Floor)/ Decimal_Place)* Decimal_Place)
   --         with
   --           Pre =>  Decimal_Place > 0.0;
   --
   --     -- Static Void VRound(Double& RdNumber,Const Double DDecimalPlace)
   --     procedure VRound(Number : in out Long_Float; Decimel_Place : in Long_Float);
   
   Dividend_Max : constant := 1_000_000_000.0;
   subtype Dividend_Long_Float is Long_Float range -Dividend_Max .. Dividend_Max;
   subtype Dividend_FLoat is Float range -Dividend_Max .. Dividend_Max;
   Divisor_Max : constant := 500.0;
   subtype Divisor_Long_Float is Long_Float range 1.0 .. Divisor_Max;
   subtype Divisor_Float is Float range 1.0 .. Divisor_Max;
   
   function Normalize_Angle (Angle           : Dividend_Long_Float;
                             Angle_Reference : Long_Float;
                             Full_Turn_Unit  : Divisor_Long_Float) return Long_Float with
     Pre => Angle_Reference in  -Full_Turn_Unit .. 0.0,
     Post => Angle_Reference <= Normalize_Angle'Result
     and Normalize_Angle'Result < Angle_Reference + Full_Turn_Unit;
   
   function Normalize_Angle (Angle           : Dividend_Float;
                             Angle_Reference : Float;
                             Full_Turn_Unit  : Divisor_Float) return Float with
     Pre => Angle_Reference in  -Full_Turn_Unit .. 0.0,
     Post => Angle_Reference <= Normalize_Angle'Result
     and Normalize_Angle'Result < Angle_Reference + Full_Turn_Unit;
   

   function Normalize_Angle_RAD (Angle_RAD       : Dividend_Long_Float;
                                 Angle_Reference : RAD_Angle := -Pi) return RAD_Angle
   is (Normalize_Angle (Angle           => Angle_RAD,
                        Angle_Reference => Angle_Reference,
                        Full_Turn_Unit => Divisor_Long_Float (Two_Pi)))
     with
       Pre =>  Angle_Reference in -Two_Pi .. 0.0,

       Post =>  Angle_Reference <= Normalize_Angle_RAD'Result
       and Normalize_Angle_RAD'Result < Angle_Reference + Two_Pi;

   function Normalize_Angle_RAD (Angle_RAD       : Dividend_FLoat;
                                 Angle_Reference : RAD_Angle_Float := Float (-Pi)) return Float
   is (Normalize_Angle (Angle           => Angle_RAD,
                        Angle_Reference => Angle_Reference,
                        Full_Turn_Unit => Divisor_Float (Two_Pi)))
     with
       Pre =>  Angle_Reference in -Divisor_Float(Two_Pi) .. 0.0,

     Post =>  Angle_Reference <= Normalize_Angle_RAD'Result
     and Normalize_Angle_RAD'Result < Angle_Reference + Divisor_Float(Two_Pi);

   function Normalize_Angle_DEG (Angle_DEG       : Dividend_Long_Float;
                                 Angle_Reference : DEG_Angle := -180.0) return DEG_Angle
   is (Normalize_Angle (Angle           => Angle_DEG,
                        Angle_Reference => Angle_Reference,
                        Full_Turn_Unit  => 360.0))
     with
       Pre =>  Angle_Reference in -360.0 .. 0.0,

       Post =>  Angle_Reference <= Normalize_Angle_DEG'Result
       and Normalize_Angle_DEG'Result < Angle_Reference + 360.0;
   function Normalize_Angle_DEG (Angle_DEG       : Dividend_FLoat;
                                 Angle_Reference : RAD_Angle_Float := Float (-Pi)) return Float
   is (Normalize_Angle (Angle           => Angle_DEG,
                        Angle_Reference => Angle_Reference,
                        Full_Turn_Unit => 360.0))
     with
       Pre =>  Angle_Reference in -360.0 .. 0.0,

       Post =>  Angle_Reference <= Normalize_Angle_DEG'Result
       and Normalize_Angle_DEG'Result < Angle_Reference + 360.0;

private
   function Saturate (Value, Min, Max : Long_Float) return Long_Float is
     (if Value < Min then Min
      elsif Value > Max then Max
      else Value);
   function Saturate (Value, Min, Max : Float) return Float is
     (if Value < Min then Min
      elsif Value > Max then Max
      else Value);

 
   
   procedure Divide
     (Dividend : Dividend_Long_Float;
      Divisor  : Divisor_Long_Float;
      Quotient : out Long_Float;
      Modulo   : out Long_Float)
     with
       Post => 0.0 <= Modulo and Modulo < Divisor;
   procedure Divide
     (Dividend : Dividend_FLoat;
      Divisor  : Divisor_Float;
      Quotient : out Float;
      Modulo   : out Float)
     with
       Post => 0.0 <= Modulo and Modulo < Divisor;
   
  
  

end Convert;
