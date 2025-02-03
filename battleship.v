// DO NOT MODIFY THE MODULE NAMES, SIGNAL NAMES, SIGNAL PROPERTIES

module battleship (
  input            clk  ,
  input            rst  ,
  input            start,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  input            pAb  ,
  input            pBb  ,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

/* Your design goes here. */

// states
parameter IDLE = 4'd0;
parameter SHOW_A = 4'd1;
parameter A_IN = 4'd2;
parameter ERROR_A = 4'd3;
parameter SHOW_B = 4'd4;
parameter B_IN = 4'd5;
parameter ERROR_B = 4'd6;
parameter SHOW_SCORE = 4'd7;
parameter A_SHOOT = 4'd8;
parameter A_SINK = 4'd9;
parameter A_WIN = 4'd10;
parameter B_SHOOT = 4'd11;
parameter B_SINK = 4'd12;
parameter B_WIN = 4'd13;

// ssd outputs
parameter SSD_I = 8'b00000110;
parameter SSD_D = 8'b01011110;
parameter SSD_L = 8'b00111000;
parameter SSD_E = 8'b01111001;
parameter SSD_A = 8'b01110111;
parameter SSD_B = 8'b01111100;
parameter SSD_0 = 8'b00111111;
parameter SSD_1 = 8'b00000110;
parameter SSD_2 = 8'b01011011;
parameter SSD_3 = 8'b01001111;
parameter SSD_4 = 8'b01100110;
parameter SSD_DASH = 8'b01000000;
parameter SSD_R = 8'b01010000;
parameter SSD_O = 8'b01011100;

// variables
reg [6:0] timer; parameter LIMIT = 7'd50;
reg [3:0] current_state, next_state;
reg [3:0] a_score, b_score;
reg [2:0] input_count;
reg [15:0] player_a_ships, player_b_ships;
reg Z;
reg dance_dir; parameter DANCE_LIMIT = 9'd15;
reg [7:0] dance_case;

always @(posedge clk) begin
  if (rst) begin
    current_state <= IDLE;
    timer <= 7'd0;
    a_score <= 4'd0;
    b_score <= 4'd0;
    player_a_ships <= 16'd0;
    player_b_ships <= 16'd0;
    input_count <= 3'd0;
    Z <= 1'b0;
    dance_dir <= 1'b0;
    dance_case <= 8'd0;
  end else begin
    current_state <= next_state;

    case (current_state)
      SHOW_A:
        begin 
          if (timer < LIMIT) timer <= timer + 1;
          else timer <= 0;
        end

      A_IN:
        begin
          if (pAb) begin
            if (player_a_ships[4*X+Y] == 0) begin
              player_a_ships[4*X+Y] <= 1;
              if (input_count > 2) input_count <= 0;
              else input_count <= input_count + 1;
            end
            else begin
              // do nothing
            end
          end
          else begin
            // do nothing
          end
        end

      ERROR_A:
        begin
          if (timer < LIMIT) timer <= timer + 1;
          else begin
            timer <= 0;
          end
        end

      SHOW_B:
        begin 
          if (timer < LIMIT) timer <= timer + 1;
          else timer <= 0;
        end
      
      B_IN:
        begin
          if (pBb) begin
            if (player_b_ships[4*X+Y] == 0) begin
              player_b_ships[4*X+Y] <= 1;
              if (input_count > 2) input_count <= 0;
              else input_count <= input_count + 1;
            end
            else begin
              // do nothing
            end
          end
          else begin
            // do nothing
          end
        end

      ERROR_B:
        begin 
          if (timer < LIMIT) timer <= timer + 1;
          else begin
            timer <= 0;
          end
        end

      SHOW_SCORE:
        begin 
          if (timer < LIMIT) timer <= timer + 1;
          else timer <= 0;
        end

      A_SHOOT:
        begin
          if (pAb) begin
            if (player_b_ships[4*X+Y] == 1) begin
              a_score <= a_score + 1;
              Z <= 1;
              player_b_ships[4*X+Y] <= 0;
            end else begin
              a_score <= a_score;
              Z <= 0;
            end
          end
          else begin
            // do nothing
          end
        end

      A_SINK:
        begin 
          if (timer < LIMIT) timer <= timer + 1;
          else begin
            timer <= 0;
            Z <= 0;
          end
        end

      A_WIN:
        begin
          if (timer < DANCE_LIMIT) timer <= timer + 1;
          else begin
            timer <= 0;
            if (dance_case == 8'd13) begin
              dance_case <= 8'd0;
            end
            else begin
              dance_case <= dance_case + 1;
            end
          end
        end
      
      B_SHOOT:
        begin
          if (pBb) begin
            if (player_a_ships[4*X+Y] == 1) begin
              b_score <= b_score + 1;
              Z <= 1;
              player_a_ships[4*X+Y] <= 0;
            end else begin
              b_score <= b_score;
              Z <= 0;
            end
          end
          else begin
            // do nothing
          end
        end

      B_SINK:
        begin 
          if (timer < LIMIT) timer <= timer + 1;
          else begin
            timer <= 0;
            Z <= 0;
          end
        end

      B_WIN:
        begin
          if (timer < DANCE_LIMIT) timer <= timer + 1;
          else begin
            timer <= 0;
            if (dance_case == 8'd13) begin
              dance_case <= 8'd0;
            end
            else begin
              dance_case <= dance_case + 1;
            end
          end
        end

      default:
        begin
          // do nothing
        end
    endcase
  
  end
end

// state transitions
always @(*) begin
  case (current_state)
      IDLE:
        begin
          if (start) next_state = SHOW_A;
          else next_state = current_state;
        end
      
      SHOW_A:
        begin
          if (timer < LIMIT) next_state = SHOW_A;
          else next_state = A_IN;
        end
          
      A_IN:
        begin
          if (pAb) begin
            if (player_a_ships[4*X+Y] == 1) begin
              next_state = ERROR_A;
            end
            else begin
              if (input_count > 2) next_state = SHOW_B;
              else next_state = A_IN;
            end
          end else next_state = A_IN; 
        end

      ERROR_A:
        begin
          if (timer < LIMIT) next_state = ERROR_A;
          else next_state = A_IN;
        end

      SHOW_B:
        begin
          if (timer < LIMIT) next_state = SHOW_B;
          else next_state = B_IN;
        end
          
      B_IN:
        begin
          if (pBb) begin
            if (player_b_ships[4*X+Y] == 1) begin
              next_state = ERROR_B;
            end
            else begin
              if (input_count > 2) next_state = SHOW_SCORE;
              else next_state = B_IN;
            end
          end else next_state = B_IN; 
        end

      ERROR_B:
        begin
          if (timer < LIMIT) next_state = ERROR_B;
          else next_state = B_IN;
        end
          
      SHOW_SCORE:
        begin
          if (timer < LIMIT) next_state = SHOW_SCORE;
          else next_state = A_SHOOT;
        end
          
      A_SHOOT:
        begin
          if (pAb) next_state = A_SINK;
          else next_state = A_SHOOT;
        end

      A_SINK:
        begin
          if (timer < LIMIT) next_state = A_SINK; 
          else begin
            if (a_score > 3) next_state = A_WIN;
            else next_state = B_SHOOT;
          end
        end

      A_WIN:
        begin
          next_state = A_WIN;
        end
        
      B_SHOOT:
        begin
          if (pBb) next_state = B_SINK;
          else next_state = B_SHOOT;          
        end

      B_SINK:
        begin
          if (timer < LIMIT) next_state = B_SINK;
          else begin
            if (b_score > 3) next_state = B_WIN;
            else next_state = A_SHOOT;
          end
        end

      B_WIN:
        begin
          next_state = B_WIN;
        end

      default:
        begin
          next_state = current_state;
        end
  endcase
end


// SSD and LED outputs
always @(*) begin
  // default values
  disp0 = 8'd0;
  disp1 = 8'd0;
  disp2 = 8'd0;
  disp3 = 8'd0;
  led = 8'b00000000;
  case (current_state)
      IDLE:
          begin
              disp3 = SSD_I;
              disp2 = SSD_D;
              disp1 = SSD_L;
              disp0 = SSD_E;
              led = 8'b10011001;
          end
          
      SHOW_A:
          begin
              disp0 = 8'd0;
              disp1 = 8'd0;
              disp2 = 8'd0;
              disp3 = SSD_A;
              led = 8'd0;
          end
          
      A_IN:
          begin
              disp3 = 8'd0;
              disp2 = 8'd0;
              case (X)
                  0: disp1 = SSD_0;
                  1: disp1 = SSD_1;
                  2: disp1 = SSD_2;
                  3: disp1 = SSD_3;
                  default: disp1 = SSD_DASH;
              endcase
              case (Y)
                  0: disp0 = SSD_0;
                  1: disp0 = SSD_1;
                  2: disp0 = SSD_2;
                  3: disp0 = SSD_3;
                  default: disp0 = SSD_DASH;
              endcase
              led = {2'b10,{input_count[1:0]},4'b0000};
          end
          
      ERROR_A:
          begin
              disp3 = SSD_E;
              disp2 = SSD_R;
              disp1 = SSD_R;
              disp0 = SSD_O;
              led = 8'b10011001;
          end
          
      SHOW_B:
          begin
              disp3 = SSD_B;
              disp2 = 8'd0;
              disp1 = 8'd0;
              disp0 = 8'd0;
              led = 8'd0;
          end
          
      B_IN:
          begin
              disp3 = 8'd0;
              disp2 = 8'd0;
              case (X)
                  0: disp1 = SSD_0;
                  1: disp1 = SSD_1;
                  2: disp1 = SSD_2;
                  3: disp1 = SSD_3;
                  default: disp1 = SSD_DASH;
              endcase
              case (Y)
                  0: disp0 = SSD_0;
                  1: disp0 = SSD_1;
                  2: disp0 = SSD_2;
                  3: disp0 = SSD_3;
                  default: disp0 = SSD_DASH;
              endcase
              led = {2'b00,{input_count[1:0]},4'b0001};
          end
          
      ERROR_B:
          begin
              disp3 = SSD_E;
              disp2 = SSD_R;
              disp1 = SSD_R;
              disp0 = SSD_O;
              led = 8'b10011001;
          end
          
      SHOW_SCORE:
          begin
              disp3 = 8'd0;
              disp2 = SSD_0;
              disp1 = SSD_DASH;
              disp0 = SSD_0;
              led = 8'b10011001;
          end
          
      A_SHOOT:
          begin
              disp3 = 8'd0;
              disp2 = 8'd0;
              case (X)
                  0: disp1 = SSD_0;
                  1: disp1 = SSD_1;
                  2: disp1 = SSD_2;
                  3: disp1 = SSD_3;
                  default: disp1 = SSD_DASH;
              endcase
              case (Y)
                  0: disp0 = SSD_0;
                  1: disp0 = SSD_1;
                  2: disp0 = SSD_2;
                  3: disp0 = SSD_3;
                  default: disp0 = SSD_DASH;
              endcase
              case (a_score)
                  0: led[5:4] = 2'b00;
                  1: led[5:4] = 2'b01;
                  2: led[5:4] = 2'b10;
                  3: led[5:4] = 2'b11;
                  default: led[5:4] = 2'b00;
              endcase
              case (b_score)
                  0: led[3:2] = 2'b00;
                  1: led[3:2] = 2'b01;
                  2: led[3:2] = 2'b10;
                  3: led[3:2] = 2'b11;
                  default: led[3:2] = 2'b00;
              endcase
              led[7:6] = 2'b10;
              led[1:0] = 2'b00;
          end
          
      A_SINK:
          begin
              disp3 = 8'd0;
              case (a_score)
                  0: disp2 = SSD_0;
                  1: disp2 = SSD_1;
                  2: disp2 = SSD_2;
                  3: disp2 = SSD_3;
                  4: disp2 = SSD_4;
                  default: disp2 = SSD_DASH;
              endcase
              disp1 = SSD_DASH;
              case (b_score)
                  0: disp0 = SSD_0;
                  1: disp0 = SSD_1;
                  2: disp0 = SSD_2;
                  3: disp0 = SSD_3;
                  4: disp0 = SSD_4;
                  default: disp0 = SSD_DASH;
              endcase
              if (Z == 1) led = 8'b11111111; /// Z??
              else led = 8'b00000000;
          end

      A_WIN:
          begin
              disp3 = SSD_A;
              case (a_score)
                  0: disp2 = SSD_0;
                  1: disp2 = SSD_1;
                  2: disp2 = SSD_2;
                  3: disp2 = SSD_3;
                  4: disp2 = SSD_4;
                  default: disp2 = SSD_DASH;
              endcase
              disp1 = SSD_DASH;
              case (b_score)
                  0: disp0 = SSD_0;
                  1: disp0 = SSD_1;
                  2: disp0 = SSD_2;
                  3: disp0 = SSD_3;
                  4: disp0 = SSD_4;
                  default: disp0 = SSD_DASH;
              endcase
              // LEDs dance!
              // yay!
              if (timer < DANCE_LIMIT) begin
                led = led;
              end
              else begin
                case (dance_case)
                  0: led = 8'b00000001;
                  1: led = 8'b00000010;
                  2: led = 8'b00000100;
                  3: led = 8'b00001000;
                  4: led = 8'b00010000;
                  5: led = 8'b00100000;
                  6: led = 8'b01000000;
                  7: led = 8'b10000000;
                  8: led = 8'b01000000;
                  9: led = 8'b00100000;
                  10: led = 8'b00010000;
                  11: led = 8'b00001000;
                  12: led = 8'b00000100;
                  13: led = 8'b00000010;
                  default:
                    led = 8'b00000000;
                endcase
              end
          end

      B_SHOOT:
          begin
              disp3 = 8'd0;
              disp2 = 8'd0;
              case (X)
                  0: disp1 = SSD_0;
                  1: disp1 = SSD_1;
                  2: disp1 = SSD_2;
                  3: disp1 = SSD_3;
                  default: disp1 = SSD_DASH;
              endcase
              case (Y)
                  0: disp0 = SSD_0;
                  1: disp0 = SSD_1;
                  2: disp0 = SSD_2;
                  3: disp0 = SSD_3;
                  default: disp0 = SSD_DASH;
              endcase
              case (a_score)
                  0: led[5:4] = 2'b00;
                  1: led[5:4] = 2'b01;
                  2: led[5:4] = 2'b10;
                  3: led[5:4] = 2'b11;
                  default: led[5:4] = 2'b00;
              endcase
              case (b_score)
                  0: led[3:2] = 2'b00;
                  1: led[3:2] = 2'b01;
                  2: led[3:2] = 2'b10;
                  3: led[3:2] = 2'b11;
                  default: led[3:2] = 2'b00;
              endcase
              led[7:6] = 2'b00;
              led[1:0] = 2'b01;
          end
          
      B_SINK:
          begin
              disp3 = 8'd0;
              case (a_score)
                  0: disp2 = SSD_0;
                  1: disp2 = SSD_1;
                  2: disp2 = SSD_2;
                  3: disp2 = SSD_3;
                  4: disp2 = SSD_4;
                  default: disp2 = SSD_DASH;
              endcase
              disp1 = SSD_DASH;
              case (b_score)
                  0: disp0 = SSD_0;
                  1: disp0 = SSD_1;
                  2: disp0 = SSD_2;
                  3: disp0 = SSD_3;
                  4: disp0 = SSD_4;
                  default: disp0 = SSD_DASH;
              endcase
              if (Z == 1) led = 8'b11111111;
              else led = 8'b00000000;
          end

      B_WIN:
          begin
              disp3 = SSD_B;
              case (a_score)
                  0: disp2 = SSD_0;
                  1: disp2 = SSD_1;
                  2: disp2 = SSD_2;
                  3: disp2 = SSD_3;
                  4: disp2 = SSD_4;
                  default: disp2 = SSD_DASH;
              endcase
              disp1 = SSD_DASH;
              case (b_score)
                  0: disp0 = SSD_0;
                  1: disp0 = SSD_1;
                  2: disp0 = SSD_2;
                  3: disp0 = SSD_3;
                  4: disp0 = SSD_4;
                  default: disp0 = SSD_DASH;
              endcase
              // LEDs dance!
              // yay!
              if (timer < DANCE_LIMIT) begin
                led = led;
              end
              else begin
                case (dance_case)
                  0: led = 8'b00000001;
                  1: led = 8'b00000010;
                  2: led = 8'b00000100;
                  3: led = 8'b00001000;
                  4: led = 8'b00010000;
                  5: led = 8'b00100000;
                  6: led = 8'b01000000;
                  7: led = 8'b10000000;
                  8: led = 8'b01000000;
                  9: led = 8'b00100000;
                  10: led = 8'b00010000;
                  11: led = 8'b00001000;
                  12: led = 8'b00000100;
                  13: led = 8'b00000010;
                  default:
                    led = 8'b00000000;
                endcase
              end
          end

      default:
          begin
              disp3 = SSD_DASH;
              disp2 = SSD_DASH;
              disp1 = SSD_DASH;
              disp0 = SSD_DASH;
              led = 8'b11111111;
          end
  endcase
end
endmodule