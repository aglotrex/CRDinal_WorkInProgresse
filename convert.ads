package Convert with SPARK_Mode is
   
 

   Miles_Per_Hour_To_Meters_Per_Second : constant Long_Float := 0.44704;
   
   Meters_Per_Second_To_Miles_Per_Hour : constant Long_Float := 2.23694;
   
   -- /*! \brief convert from MetersPerSecond to MilesPerHour  */
   MetersPerSecondToKnots : constant Long_Float := 1.94384;
        
   -- /*! \brief convert from MetersPerSecond to MilesPerHour  */
   KnotsToMetersPerSecond : constant Long_Float := 0.514444;

   -- /*! \brief convert from meters to feet  */
   MetersToFeet : constant Long_Float := 3.280839895;

   -- /*! \brief convert from feet to meters  */
   FeetToMeters : constant Long_Float := 0.3048;
   
      -- /*! \brief convert from degrees to radians  */
   DegreesToRadians : constant Long_Float := 0.01745329251994;

   -- /*! \brief convert from degrees to radians  */
   function To_Radians(degrees : Long_Float) return Long_Float is (degrees * Convert.DegreesToRadians);


  -- /*! \brief convert from radians to degrees  */
   RadiansToDegrees : constant Long_Float := 57.29577951308232;

   -- /*! \brief convert from radians to degrees  */
   function To_Degrees(Radians : Long_Float) return Long_Float is (Radians * Convert.RadiansToDegrees);
       

 

   -- /*! \brief convert PI  */
   Pi : constant Long_Float := 3.14159265359;

   -- /*! \brief convert PI/2.0  */
   Pi_O2 : constant Long_Float := Convert.Pi/2.0;

   -- /*! \brief convert 3.0*PI/2.0  */
   three_Pi_O2 : constant Long_Float := 3.0*Convert.Pi_O2;

   -- /*! \brief convert PI/8.0  */
   Pi_O8 : constant Long_Float := Convert.Pi/8.0;

   -- /*! \brief convert PI/10.0  */
   Pi_O10 : constant Long_Float :=Convert.Pi/10.0;

   -- /*! \brief convert PI/18.0  */
   Pi_O18 : constant Long_Float := Convert.Pi/18.0;

   -- /*! \brief convert 2*PI  */
   Two_Pi : constant Long_Float := 2.0 * Convert.Pi;
        
   -- /*! \brief gravitational acceleration ft/sec2 */
   Gravity_fp_s2 : constant Long_Float := 32.174;  --  // ft/sec^2
        
        
   -- /*! \brief gravitational acceleration m/sec^2 */
   Gravity_mps2 : constant Long_Float := 9.80665;   --  // m/sec^2
          
   type En_Relational_Operators is (  enGreater,
                                      enGreaterEqual,
                                      enLess,
                                      enLessEqual,
                                      enEqual,
                                      enTotalRelationalOperators);
      
   function Compare(Argument1 : Long_Float;
                    Argument2 : Long_Float;
                    rel_Operator : En_Relational_Operators;
                    Epsilon   : Long_Float :=(10.0**(-9)) ) return Boolean;
  
            
   function Compare(Argument1 : Float;
                    Argument2 : Float;
                    rel_Operator : En_Relational_Operators;
                    Epsilon   : Float := (10.0**(-9))) return Boolean;
   
   function Normalize_Angle_RAD( Angle_RAD : Long_Float;
                                 Angle_Reference : Long_Float := - Pi ) return Long_Float with 
     Pre =>  - Two_Pi <=  Angle_Reference       and Angle_Reference             <= 0.0 ,
     Post => Angle_Reference <=  Normalize_Angle_RAD'Result and Normalize_Angle_RAD'Result  <= Angle_Reference + Two_Pi;
   
   function Normalize_Angle_Deg( Angle_RAD : Long_Float;
                                 Angle_Reference : Long_Float := - 180.0 ) return Long_Float with
     Pre =>  -360.0 <= Angle_Reference and Angle_Reference <= 0.0,
     Post => Angle_Reference <=  Normalize_Angle_Deg'Result and Normalize_Angle_Deg'Result  <= Angle_Reference + 360.0;
   
   function Normalize_Angle_RAD( Angle_RAD : Float;
                                 Angle_Reference : Float :=Float(- Pi) ) return Float with
     Pre =>  - Float(Two_Pi) <=  Angle_Reference       and Angle_Reference             <= 0.0 ,
     Post => Angle_Reference <=  Normalize_Angle_RAD'Result and Normalize_Angle_RAD'Result  <= Angle_Reference + Float(Two_Pi);
   
   function Normalize_Angle_Deg( Angle_RAD : Float;
                                 Angle_Reference : Float := - 180.0 ) return Float with
     Pre =>  -360.0 <= Angle_Reference and Angle_Reference <= 0.0,
     Post => Angle_Reference <=  Normalize_Angle_Deg'Result and Normalize_Angle_Deg'Result  <= Angle_Reference + 360.0;
   
   
   function iRound(Number : Long_Float) return Integer is (Integer(Number + 0.5));
   
   --static void dRound(double dNumber,const double dDecimalPlace)
   function dRound(Number, Decimal_Place  : Long_Float) return Long_Float
   is (Long_Float'Floor((Number/Decimal_Place) + 0.5) * Decimal_Place);
   
   -- static void vRound(double& rdNumber,const double dDecimalPlace)
   procedure vRound(Number : in out Long_Float; Decimel_Place : in Long_Float);
     
   
      
      
   

end Convert;
