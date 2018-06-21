CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size
PROJECT = project_3
CFLAGS = -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16
MCU_S = -D__weak=__attribute__((weak)) -D__packed=__attribute__((__packed__)) -DUSE_HAL_DRIVER -DSTM32F303xC
DRIVERS = -I"Drivers/STM32F3xx_HAL_Driver/Inc" -I"Drivers/STM32F3xx_HAL_Driver/Inc/Legacy" -I"Drivers/CMSIS/Device/ST/STM32F3xx/Include" -I"Drivers/CMSIS/Include" -I"Inc" -Og -g3 -Wall -fmessage-length=0 -ffunction-sections -c -fmessage-length=0
SPCS = -specs=nosys.specs -specs=nano.specs -T"STM32F303VCTx_FLASH.ld" -Wl,-Map=output.map -Wl,--gc-sections
SFILES= $(wildcard startup/*.s)
CFILES = $(wildcard Src/*.c)
CFILES += $(wildcard Drivers/STM32F3xx_HAL_Driver/Src/*.c)
SFILES_O = $(patsubst %.s, %.o, $(SFILES))
CFILES_O = $(patsubst %.c, %.o, $(CFILES))


all: $(PROJECT).elf

$(PROJECT).elf: $(SFILES_O) $(CFILES_O) ../STM32F303VCTx_FLASH.ld
	$(CC) $(CFLAGS) $(SPCS) -o "$(PROJECT).elf" $(CFILES_O) $(SFILES_O) -lm
	$(OBJCOPY) -O binary "$(PROJECT).elf" "$(PROJECT).bin"
	$(SIZE) "$(PROJECT).elf"

%.o: %.s
	$(AS) $(CFLAGS) -g -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) $(MCU_S) $(DRIVERS) -o $@ $<

clean:
	rm -rf Src/*.o
	rm -rf Drivers/STM32F3xx_HAL_Driver/Src/*.o
	rm -rf startup/*.o
