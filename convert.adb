package body Convert with SPARK_Mode is
   function To_Degrees (Radians : RAD_Angle) return DEG_Angle is 
     (Saturate(Radians * Radians_To_Degrees,
               DEG_Angle'First,
               DEG_Angle'Last));
   
   procedure Divide
     (Dividend : in Dividend_Float;
      Divisor  : in Divisor_Float;
      Quotient : out Float;
      Modulo   : out Float)
   is
      Quot : Dividend_Float;
   begin
      if 0.0 <=  Dividend and Dividend < Divisor then
         Quotient := 0.0;
         Modulo := Dividend;
         return;
      end if;
      pragma Assert(Divisor >= 1.0);
      pragma Assert(Dividend_Float'First / Divisor in Dividend_Float'First .. 0.0 );
      pragma Assert(Dividend_Float'Last  / Divisor in 0.0 .. Dividend_Float'Last );
      pragma Assert(Dividend in Dividend_Float'First .. Dividend_Float'Last);
      pragma Assert(Dividend / Divisor in Dividend_Float'First .. Dividend_Float'Last);
      Quot   := Dividend_Float'Floor (Dividend / Divisor);
      Modulo := Saturate (Value => Dividend - Divisor * Quot,
                          Min   => 0.0,
                          Max   => Divisor);
      Quotient := Quot;
      if Modulo = Divisor then
        
         Quotient   := Quotient + 1.0;
         Modulo := 0.0;
      end if;
   end Divide;
   
   procedure Divide
     (Dividend : in Dividend_Long_Float;
      Divisor  : in Divisor_Long_Float;
      Quotient : out Long_Float;
      Modulo   : out Long_Float)
   is
      Quot : Dividend_Long_Float;
   begin
      if 0.0 <=  Dividend and Dividend < Divisor then
         Quotient := 0.0;
         Modulo := Dividend;
         return;
      end if;
      pragma Assert(Divisor >= 1.0);
      pragma Assert(Dividend_Long_Float'First / Divisor in Dividend_Long_Float'First .. 0.0 );
      pragma Assert(Dividend_Long_Float'Last  / Divisor in 0.0 .. Dividend_Long_Float'Last );
      pragma Assert(Dividend in Dividend_Long_Float'First .. Dividend_Long_Float'Last);
      pragma Assert(Dividend / Divisor in Dividend_Long_Float'First .. Dividend_Long_Float'Last);
      Quot   := Dividend_Long_Float'Floor (Dividend / Divisor);
      Modulo := Saturate (Value => Dividend - Divisor * Quot,
                          Min   => 0.0,
                          Max   => Divisor);
      Quotient := Quot;
      if Modulo = Divisor then
        
         Quotient   := Quotient + 1.0;
         Modulo := 0.0;
      end if;

     
   end Divide;

   function Compare (Argument1    : Long_Float;
                     Argument2    : Long_Float;
                     Rel_Operator : En_Relational_Operators;
                     Epsilon      : Long_Float := (10.0**(-9))) return Boolean
   is
   begin

      case Rel_Operator is
         --  bReturn = (dArgument1 > dArgument2);
         when  EnGreater      =>  return Argument1 > Argument2;

            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when EnGreaterEqual =>  return (Compare (Argument1, Argument2, EnGreater)
                                         or
                                           Compare (Argument1, Argument2, EnEqual, Epsilon));

            --  bReturn = (dArgument1 < dArgument2);
         when EnLess         => return (Argument1 < Argument2);

            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when EnLessEqual    => return (Compare (Argument1, Argument2, EnLess)
                                        or
                                          Compare (Argument1, Argument2, EnEqual, Epsilon));

            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs (Argument1 - Argument2) <= Epsilon);
      end case;

   end Compare;

   function Compare (Argument1 : Float;
                     Argument2 : Float;
                     Rel_Operator : En_Relational_Operators;
                     Epsilon   : Float := (10.0**(-9))) return Boolean

   is
   begin

      case Rel_Operator is
         --  bReturn = (dArgument1 > dArgument2);
         when  EnGreater      =>  return Argument1 > Argument2;

            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when EnGreaterEqual =>  return (Compare (Argument1, Argument2, EnGreater)
                                         or
                                           Compare (Argument1, Argument2, EnEqual, Epsilon));

            --  bReturn = (dArgument1 < dArgument2);
         when EnLess         => return (Argument1 < Argument2);

            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when EnLessEqual    => return (Compare (Argument1, Argument2, EnLess)
                                        or
                                          Compare (Argument1, Argument2, EnEqual, Epsilon));

            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs (Argument1 - Argument2) <= Epsilon);
      end case;
   end Compare;

   function Normalize_Angle (Angle           : Dividend_Long_Float;
                             Angle_Reference : Long_Float;
                             Full_Turn_Unit  : Divisor_Long_Float) return Long_Float is
      --  Full_Turn_Unit : Long_Float := Two_Pi;
      Mod_Angle : Long_Float;
      N         : Long_Float;
      Result    : Long_Float;
   begin
      pragma Assert (Full_Turn_Unit > 0.0);
      --  double dModAngle = modulo (dAngleRad,/Full_Turn/);
      Divide (Dividend => Angle,
              Divisor  => Full_Turn_Unit,
              Quotient => N,
              Modulo   => Mod_Angle);
      pragma Assert(0.0 <= Mod_Angle and Mod_Angle < Full_Turn_Unit);

      --  assert( dAngleReference <= 0.0 && dAngleReference >= /Full_Turn/ );
      --  if( bCompareDouble(dModAngle, dAngleReference, enLess) )
      --  {
      --    dModAngle += /Full_Turn/;
      --  }
      ---- unreachable code
      --   0.0 <= Mod_Angle
      --  Angle_Reference <= 0.0
      --   => NOT  Mod_Angle < Angle-Reference

      --  else if( bCompareDouble(dModAngle, (dAngleReference+ /Full_Turn/ ), enGreaterEqual) )

      if Angle_Reference <= Mod_Angle  - Full_Turn_Unit then

         Result := Mod_Angle - Full_Turn_Unit;

         pragma Assert (Angle_Reference <= Result);
         pragma Assert (Result < 0.0);
      else
         Result := Mod_Angle;
         pragma Assert (Angle_Reference  > Result - Full_Turn_Unit);
         pragma Assert (0.0 <= Result );

      end if;


      Result :=  Saturate (Result, Angle_Reference, Angle_Reference +  Full_Turn_Unit);
      Result := (if Result = Angle_Reference + Full_Turn_Unit then Angle_Reference else Result);

      return Result;
   end Normalize_Angle;
   function Normalize_Angle (Angle           : Dividend_Float;
                             Angle_Reference : Float;
                             Full_Turn_Unit  : Divisor_Float) return Float is
      --  Full_Turn_Unit : Long_Float := Two_Pi;
      Mod_Angle : Float;
      N         : Float;
      Result    : Float;
   begin
      pragma Assert (Full_Turn_Unit > 0.0);
      --  double dModAngle = modulo (dAngleRad,/Full_Turn/);
      Divide (Dividend => Angle,
              Divisor  => Full_Turn_Unit,
              Quotient => N,
              Modulo   => Mod_Angle);
      pragma Assert(0.0 <= Mod_Angle and Mod_Angle < Full_Turn_Unit);

      --  assert( dAngleReference <= 0.0 && dAngleReference >= /Full_Turn/ );
      --  if( bCompareDouble(dModAngle, dAngleReference, enLess) )
      --  {
      --    dModAngle += /Full_Turn/;
      --  }
      ---- unreachable code
      --   0.0 <= Mod_Angle
      --  Angle_Reference <= 0.0
      --   => NOT  Mod_Angle < Angle-Reference

      --  else if( bCompareDouble(dModAngle, (dAngleReference+ /Full_Turn/ ), enGreaterEqual) )

      if Angle_Reference <= Mod_Angle  - Full_Turn_Unit then

         Result := Mod_Angle - Full_Turn_Unit;

         pragma Assert (Angle_Reference <= Result);
         pragma Assert (Result < 0.0);
      else
         Result := Mod_Angle;
         pragma Assert (Angle_Reference  > Result - Full_Turn_Unit);
         pragma Assert (0.0 <= Result );

      end if;


      Result :=  Saturate (Result, Angle_Reference, Angle_Reference +  Full_Turn_Unit);
      Result := (if Result = Angle_Reference + Full_Turn_Unit then Angle_Reference else Result);

      return Result;
   end Normalize_Angle;

   --     --  static void vRound(double& rdNumber,const double dDecimalPlace)
   --     procedure VRound (Number : in out Long_Float;
   --                       Decimel_Place : Long_Float)is
   --     begin
   --        Number := 0.0;
   --        --DRound (Number        => Number,
   --       -- Decimal_Place => Decimel_Place);
   --     end VRound;

end Convert;
