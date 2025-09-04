#TODO: Fill up the contents below in order to reference your assignment 3 git contents
LDD_VERSION = 6e6b0bf439b77a88248b00f1bf55ee7beebb3824
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
# Your site should start with git@github.com:
LDD_SITE = "git@github.com:cu-ecen-aeld/assignment-7-ijking1144.git"
LDD_SITE_METHOD = git
LDD_GIT_SUBMODULES = YES

define LDD_BUILD_CMDS
	@echo "=== BUILDING LDD FOR ARM64 ==="
	@echo "Build directory: $(@D)"
	@echo "Linux kernel dir: $(LINUX_DIR)"
	@echo "Cross compiler: $(TARGET_CROSS)"
	
	@ls -la $(@D)/ || echo "Build directory not found"
	@ls -la $(@D)/scull/ || echo "scull directory not found"
	@ls -la $(@D)/misc-modules/ || echo "misc-modules directory not found"
	
	# Build misc-modules using kernel build system
	@if [ -d "$(@D)/misc-modules" ]; then \
		echo "Building misc-modules..."; \
		$(MAKE) -C $(LINUX_DIR) M=$(@D)/misc-modules \
		ARCH=arm64 \
		CROSS_COMPILE=$(TARGET_CROSS) \
		modules; \
	fi
	
	# Build scull using kernel build system  
	@if [ -d "$(@D)/scull" ]; then \
		echo "Building scull..."; \
		$(MAKE) -C $(LINUX_DIR) M=$(@D)/scull \
		ARCH=arm64 \
		CROSS_COMPILE=$(TARGET_CROSS) \
		modules; \
	fi
	
	# Build aesd-char-driver using kernel build system
	#@if [ -d "$(@D)/aesd-char-driver" ]; then \
	#	echo "Building aesd-char-driver..."; \
	#	$(MAKE) -C $(LINUX_DIR) M=$(@D)/aesd-char-driver \
	#	ARCH=arm64 \
	#	CROSS_COMPILE=$(TARGET_CROSS) \
	#	modules; \
	#fi
	
	@echo "=== BUILD COMPLETE ==="
endef

# TODO add your writer, finder and finder-test utilities/scripts to the installation steps below
define LDD_INSTALL_TARGET_CMDS
	$(INSTALL) -d 0755 $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/
	$(INSTALL) -m 0644 $(@D)/scull/*.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/
	$(INSTALL) -m 0644 $(@D)/misc-modules/*.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/
	#$(INSTALL) -m 0644 $(@D)/aesd-char-driver/*.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/
	#$(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar_load $(TARGET_DIR)/usr/bin
	#$(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar_unload $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/scull/scull_load $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/scull/scull_unload $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_load $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_unload $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
