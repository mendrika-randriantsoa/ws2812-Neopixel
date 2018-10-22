# WS2812B DRIVER FOR FPGAS written in VHDL


## Entity description
### top_decoration
Low level driver for  WS2812B RGB LEDs.
       
            +-------------------+
            |                   |
    CLK----->                   |
            |                   |       
            |     DECORATION    -----> LEDs
    ENABLE-->                   |
            |                   |
            |                   |   
            +-------------------+

## Demo
### Decoration

Rainbow decoration

Make sure the `CLKS_PER_BIT`, `CLKS_PER_TOH`, `CLKS_PER_T1H` and `PIX_NUMBER` are set .


## Author

Mendrika RANDRIANTSOA

## License

MIT