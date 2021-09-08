########################################
# Simple application Makefile
########################################

########################################
# Settings
########################################
# Compiler settings
## For SDK Compilation
CFLAGS = -Wall -DLOG_USE_COLOR -ggdb
LDFLAGS =

# Makefile settings
APPNAME = $(notdir $(abspath .))
EXT = .c
SRCDIR = src
OBJDIR = obj

########################################
# Dynamically set
########################################
SRC = $(wildcard $(SRCDIR)/*$(EXT))
OBJ = $(SRC:$(SRCDIR)/%$(EXT)=$(OBJDIR)/%.o)
DEP = $(OBJ:$(OBJDIR)/%.o=%.d)

# UNIX-based OS variables & settings
RM = rm
DELOBJ = $(OBJ)

########################################
# Targets
########################################
all: $(APPNAME)
	@printf "### Finished Make-Build ###\n\n"

# Builds the app
$(APPNAME): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Creates the dependecy rules
%.d: $(SRCDIR)/%$(EXT)
	@$(CPP) $(CFLAGS) $< -MM -MT $(@:%.d=$(OBJDIR)/%.o) >$@

# Includes all .h files
-include $(DEP)

# Building rule for .o files and its .c in combination with all .h
$(OBJDIR)/%.o: $(SRCDIR)/%$(EXT)
	$(CC) $(CFLAGS) -o $@ -c $<

# Cleans complete project
.PHONY: clean
clean:
	$(RM) $(DELOBJ) $(DEP) $(APPNAME)
	@printf "### Cleaned ###\n\n"

# Cleans, build and executed complete project
.PHONY: exec
exec: clean
exec: all
exec: 
	@printf "### Starting binary ###\n\n"
	@./$(APPNAME)
