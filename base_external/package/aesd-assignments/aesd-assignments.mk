
##############################################################
#
# AESD-ASSIGNMENTSh
#
##############################################################

#TODO: Fill up the contents below in order to reference your assignment 3 git contents
AESD_ASSIGNMENTS_VERSION = '547a857d0f9d698b242abc93af97d0e9f82292d0'
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
# Your site should start with git@github.com:
AESD_ASSIGNMENTS_SITE = 'git@github.com:cu-ecen-aeld/assignment-5-ijking1144.git'
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

define AESD_ASSIGNMENTS_BUILD_CMDS
	@echo "=== BUILDING AESD_ASSIGNMENTS ==="
	
	# Build finder-app
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/finder-app all
	
	# Remove any pre-compiled binaries and force rebuild
	@echo "Removing any pre-compiled binaries..."
	rm -f $(@D)/server/aesdsocket
	
	@echo "Building server with cross-compilation..."
	@echo "Using CC: $(TARGET_CC)"
	$(MAKE) -C $(@D)/server \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		V=1 \
		all
	
	@echo "Checking built binary:"
	@file $(@D)/server/aesdsocket
	@echo "=== BUILD COMPLETE ==="
endef

# TODO add your writer, finder and finder-test utilities/scripts to the installation steps below
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(INSTALL) -d 0755 $(@D)/conf/ $(TARGET_DIR)/etc/finder-app/conf/
	$(INSTALL) -m 0755 $(@D)/conf/* $(TARGET_DIR)/etc/finder-app/conf/
	$(INSTALL) -m 0755 $(@D)/assignment-autotest/test/assignment4/* $(TARGET_DIR)/bin
	$(INSTALL) -m 0755 $(@D)/finder-app/writer $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/finder-app/finder.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/finder-app/finder-test.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/finder-app/dependencies.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/server/S99aesdsocket $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 0755 $(@D)/server/aesdsocket $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
