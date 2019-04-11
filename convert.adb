
package body Convert with SPARK_Mode is

   procedure Modulo (Dividend, Divisor : in  Long_Float ;
                     Quotient, Result  : out Long_Float) is
      Quotient_Floor   : Long_Float;
      Quotient_Ceiling : Long_Float;
   begin
      if 0.0 <= Dividend and Dividend < Divisor then
         Quotient_Floor := 0.0 ;
      else
         Quotient := Dividend/Divisor;
         Quotient_Floor   := Long_Float'Floor  (Quotient);
         Quotient_Ceiling := Long_Float'Ceiling(Quotient);
         
      end if;
      Result := Dividend - (Divisor * Quotient_Floor);
      Quotient := Quotient_Floor;
      
     
   end Modulo;
   
   
   function Compare (Argument1    : Long_Float;
                     Argument2    : Long_Float; 
                     Rel_Operator : En_Relational_Operators;
                     Epsilon      : Long_Float :=(10.0**(-9)) ) return Boolean
   is
   begin
      
         
      case Rel_Operator is 
         -- bReturn = (dArgument1 > dArgument2);
         when  EnGreater      =>  return Argument1 > Argument2;
               
            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when EnGreaterEqual =>  return(Compare(Argument1,Argument2,EnGreater)
                                        or 
                                          Compare(Argument1,Argument2,EnEqual,Epsilon));
               
            -- bReturn = (dArgument1 < dArgument2);   
         when EnLess         => return (Argument1 < Argument2);
               
            -- bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when EnLessEqual    => return (Compare(Argument1,Argument2,EnLess)
                                        or 
                                          Compare(Argument1,Argument2,EnEqual,Epsilon));
               
            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs(Argument1 - Argument2) <= Epsilon);
      end case;
         
   end Compare;
   
   function Compare(Argument1 : Float;
                    Argument2 : Float;
                    Rel_Operator : En_Relational_Operators;
                    Epsilon   : Float := (10.0**(-9))) return Boolean
   
   is
   begin
         
      case Rel_Operator is 
         -- bReturn = (dArgument1 > dArgument2);
         when  EnGreater      =>  return Argument1 > Argument2;
               
            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when EnGreaterEqual =>  return(Compare(Argument1,Argument2,EnGreater)
                                        or 
                                          Compare(Argument1,Argument2,EnEqual,Epsilon));
               
            -- bReturn = (dArgument1 < dArgument2);   
         when EnLess         => return (Argument1 < Argument2);
               
            -- bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when EnLessEqual    => return (Compare(Argument1,Argument2,EnLess)
                                        or 
                                          Compare(Argument1,Argument2,EnEqual,Epsilon));
               
            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs(Argument1 - Argument2) <= Epsilon);
      end case;
   end Compare;
   
   function Normalize_Angle ( Angle           : Long_Float;
                              Angle_Reference : Long_Float;
                              Full_Turn_Unit :Long_Float ) return Long_Float is
      --  Full_Turn_Unit : Long_Float := Two_Pi;
      Mod_Angle : Long_Float;
      N         : Long_Float;
      Result    : Long_Float; 
   begin 
      pragma Assert (Full_Turn_Unit > 0.0);
      -- double dModAngle = modulo (dAngleRad,/Full_Turn/);
      Modulo (Dividend => Angle,
              Divisor  => Full_Turn_Unit,
              Quotient => N,
              Result   => Mod_Angle);
      
      -- assert( dAngleReference <= 0.0 && dAngleReference >= /Full_Turn/ );
      -- if( bCompareDouble(dModAngle, dAngleReference, enLess) )
      -- {
      --    dModAngle += /Full_Turn/;
      -- }
      ---- unreachable code 
      --   0.0 <= Mod_Angle 
      --  Angle_Reference <= 0.0
      --   => NOT  Mod_Angle < Angle-Reference
         
      --  else if( bCompareDouble(dModAngle, (dAngleReference+ /Full_Turn/ ), enGreaterEqual) )   
      
      if Angle_Reference <= Mod_Angle  - Full_Turn_Unit then
         
         Result := Mod_Angle - Full_Turn_Unit;
 
         pragma Assert(Angle_Reference <= Result);
         pragma Assert(Result < Angle_Reference + Full_Turn_Unit );
      else
         Result := Mod_Angle;
         pragma Assert(Angle_Reference  > Result - Full_Turn_Unit);
         pragma Assert( Mod_Angle <= Full_Turn_Unit);
                      
      end if;
      
      pragma Assert( Angle_Reference <= Result
                     and Result -  Full_Turn_Unit  < Angle_Reference );
      return Result;
   end Normalize_Angle;
      
      
    
   
   -- static void vRound(double& rdNumber,const double dDecimalPlace)
   procedure VRound(Number : in out Long_Float; 
                    Decimel_Place : in Long_Float)is 
   begin
      Number := DRound(Number        => Number,
                       Decimal_Place => Decimel_Place);
   end VRound;
        
                      
      

end Convert;
