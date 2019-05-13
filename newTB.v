`timescale 1ns / 1ps

module testbench(
);

  reg [2:0] n_gasoline_pumps; // for setup mode, max 6
  reg [2:0] n_diesel_pumps;   // for setup mode, max 6
  reg [3:0] fuel_amount;      // for add car mode, max 8
  reg fuel_type;				    // for add car mode, gas(0) or diesel(1)
  reg [1:0] mode;
  reg CLK; 
  wire [5:0] pump_status; 				 // pump is working or not, max 6 pumps
  wire is_gasoline_queue_not_full;		 // gasoline queue full warning
  wire is_diesel_queue_not_full;  		 // diesel queue full warning
  wire [3:0] n_cars_in_gasoline_queue; // to represent max 9 on 1 7-seg display
  wire [3:0] n_cars_in_diesel_queue;   // to represent max 9 on 1 7-seg display
  wire [7:0] total_gasoline_needed;    // to represent max 99 on 2 7-seg displays
  wire [7:0] total_diesel_needed;      // to represent max 99 on 2 7-seg displays

  reg [15:0] passCounter;

  lab4_2 ins(
    mode,
    n_gasoline_pumps, 
    n_diesel_pumps,
    fuel_amount,
    fuel_type,
    CLK, 
    pump_status, 
    is_gasoline_queue_not_full,
    is_diesel_queue_not_full,
    n_cars_in_gasoline_queue, 
    n_cars_in_diesel_queue,
    total_gasoline_needed, 
    total_diesel_needed,
    invalid_gasoline_car,
    invalid_diesel_car,
    invalid_setup_params
  );

  initial CLK = 1;
  
  initial passCounter = 0;

  always #5 CLK = ~CLK;

  initial
    begin

      #1;     
      // MONITOR OUTPUT
      $display("\nTIME\tPUMPS\t?GAS\t?DSL\tN-GAS\tN-DSL\tF-GAS\tF-DSL\tINV-GAS\tINV-DSL\tINV-STP\n");

      $monitor("T: %3d\t%b\t%b\t%b\t%d\t%d\t%d\t%d\t%b\t%b\t%b\n",
               $time, pump_status, is_gasoline_queue_not_full, is_diesel_queue_not_full,
               n_cars_in_gasoline_queue, n_cars_in_diesel_queue,
               total_gasoline_needed, total_diesel_needed,
               invalid_gasoline_car, invalid_diesel_car, invalid_setup_params);


      mode = 2'b10;                    // SETUP MODE
      n_gasoline_pumps = 4;
      n_diesel_pumps   = 3;


      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 0
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 15
       && total_gasoline_needed == 255
       && total_diesel_needed == 255
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 1) begin $display("timeUnit1: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit1: FAILED");
      

      n_gasoline_pumps = 0;
      n_diesel_pumps = 1;

      #10;

      if( pump_status == 6'b100000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 0
       && total_gasoline_needed == 255
       && total_diesel_needed == 0
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit2: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit2: FAILED");
      
      mode = 2'b01;                    // CAR ENTRANCE MODE
      fuel_type = 1;
      fuel_amount = 6;

      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 0
       && total_gasoline_needed == 255
       && total_diesel_needed == 6
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit3: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit3: FAILED");


      fuel_type = 0;
      fuel_amount = 3;

      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 0
       && total_gasoline_needed == 255
       && total_diesel_needed == 5
       && invalid_gasoline_car == 1
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit4: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit4: FAILED");

      
      fuel_type = 1;
      fuel_amount = 1;

      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 1
       && total_gasoline_needed == 255
       && total_diesel_needed == 5
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit5: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit5: FAILED");

      
      fuel_type = 1;
      fuel_amount = 3;

      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 2
       && total_gasoline_needed == 255
       && total_diesel_needed == 7
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit6: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit6: FAILED");


      mode = 0;                        // SIMULATION MODE

      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 2
       && total_gasoline_needed == 255
       && total_diesel_needed == 6
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit7: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit7: FAILED");

      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 2
       && total_gasoline_needed == 255
       && total_diesel_needed == 5
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit8: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit8: FAILED");


      #10;

      if( pump_status == 6'b100000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 2
       && total_gasoline_needed == 255
       && total_diesel_needed == 4
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit9: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit9: FAILED");

      
      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 1
       && total_gasoline_needed == 255
       && total_diesel_needed == 4
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit10: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit10: FAILED");


      #10;

      if( pump_status == 6'b100000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 1
       && total_gasoline_needed == 255
       && total_diesel_needed == 3
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit11: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit11: FAILED");


      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 0
       && total_gasoline_needed == 255
       && total_diesel_needed == 3
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit12: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit12: FAILED");


      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 0
       && total_gasoline_needed == 255
       && total_diesel_needed == 2
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit13: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit13: FAILED");


      #10;

      if( pump_status == 6'b000000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 0
       && total_gasoline_needed == 255
       && total_diesel_needed == 1
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit14: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit14: FAILED");


      #10;

      if( pump_status == 6'b100000
       && is_gasoline_queue_not_full == 0
       && is_diesel_queue_not_full == 1
       && n_cars_in_gasoline_queue == 15
       && n_cars_in_diesel_queue == 0
       && total_gasoline_needed == 255
       && total_diesel_needed == 0
       && invalid_gasoline_car == 0
       && invalid_diesel_car == 0
       && invalid_setup_params == 0) begin $display("timeUnit15: PASSED"); passCounter = passCounter + 1; end
                                     else  $display("timeUnit15: FAILED");                               

      $display("\n\n\t\tYou have passed     %d / 15\tof tests.\n\n", passCounter);

      $finish;

    end

endmodule
