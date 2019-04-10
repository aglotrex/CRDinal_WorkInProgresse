
package body convert with SPARK_Mode is

   procedure modulo(Dividend, Divisor : in  Long_Float ;
                    Quotient, Result  : out Long_Float) is
    
   begin
      if (0.0 <= Dividend and Dividend < Divisor) then
         Quotient := 0.0 ;
      else
         Quotient := Dividend/Divisor;
         Quotient_Floor := Long_Float'Floor  (MultiplIcator);
         Quotient_Ceiling := Long_Float'Ceiling(MultiplIcator);
         
      end if;
      result := Dividend - (Divisor * Quotient);
      
     
   end modulo;
   
   procedure modulo_Loop(Dividend, Divisor : in  Long_Float ;
                         Quotient, Result  : out Long_Float) is
   
      Is_Neg_Dividend : constant Boolean := Dividend < 0.0;
   begin
      Quotient := 0.0;
      Result := abs(Dividend);
      while Result >= Divisor loop
         Result := Result - Divisor;
         Quotient := Quotient + 1.0;
       --  pragma Loop_Invariant(Dividend = Result + (Quotient* Divisor));
      end loop;
      
      pragma Assert(0.0 <= result and result < Divisor );
      
      Quotient := (if Is_Neg_Dividend then (- Quotient) else Quotient);
      Result   := (if Is_Neg_Dividend then (- Result  ) else Result  );
   end modulo_Loop;
   
   function Compare(Argument1 : Long_Float;
                    Argument2 : Long_Float;
                    rel_Operator : En_Relational_Operators;
                    Epsilon   : Long_Float :=(10.0**(-9)) ) return Boolean
   is
   begin
      
         
      case rel_Operator is 
         -- bReturn = (dArgument1 > dArgument2);
         when  enGreater      =>  return Argument1 > Argument2;
               
            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enGreaterEqual =>  return(Compare(Argument1,Argument2,enGreater)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            -- bReturn = (dArgument1 < dArgument2);   
         when enLess         => return (Argument1 < Argument2);
               
            -- bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enLessEqual    => return (Compare(Argument1,Argument2,enLess)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs(Argument1 - Argument2) <= Epsilon);
      end case;
         
   end Compare;
   
   function Compare(Argument1 : Float;
                    Argument2 : Float;
                    rel_Operator : En_Relational_Operators;
                    Epsilon   : Float := (10.0**(-9))) return Boolean
   
   is
   begin
         
      case rel_Operator is 
         -- bReturn = (dArgument1 > dArgument2);
         when  enGreater      =>  return Argument1 > Argument2;
               
            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enGreaterEqual =>  return(Compare(Argument1,Argument2,enGreater)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            -- bReturn = (dArgument1 < dArgument2);   
         when enLess         => return (Argument1 < Argument2);
               
            -- bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enLessEqual    => return (Compare(Argument1,Argument2,enLess)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
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
      modulo (Dividend => Angle,
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
   procedure vRound(Number : in out Long_Float; 
                    Decimel_Place : in Long_Float)is 
   begin
      Number := dRound(Number        => Number,
                       Decimal_Place => Decimel_Place);
   end vRound;
        
                      
      

end convert;
