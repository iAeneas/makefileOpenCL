TARGET  := run

CPPOBJDIR = cppobjs

CPPSOURCES := $(wildcard *.cpp)
CPPOBJS := $(CPPSOURCES:%.cpp=$(CPPOBJDIR)/%.o)

COBJDIR = cobjs

CSOURCES := $(wildcard *.c)
COBJS := $(CSOURCES:%.c=$(COBJDIR)/%.o)

OBJS = $(CPPOBJS) $(COBJS)

OPT_FLAGS   := -fno-strict-aliasing -O2

#INC := -I/opt/tools/libraries/cuda-6.0/include

#LIB := -L/opt/tools/libraries/cuda-6.0/lib64
LIB += -lOpenCL

CXXFLAGS := -m64 -DUNIX $(WARN_FLAGS) $(OPT_FLAGS) $(INC)
CFLAGS := -m64 -std=c99 -DUNIX $(WARN_FLAGS) $(OPT_FLAGS) $(INC)

LDFLAGS := $(LIB)

.PHONY: clean

$(TARGET): $(CPPOBJDIR) $(COBJDIR) $(CPPOBJS) $(COBJS)
	g++ -fPIC -o $(TARGET) $(COBJS) $(CPPOBJS) $(LDFLAGS)

$(CPPOBJS): $(CPPOBJDIR)/%.o: %.cpp
	@echo "compile $@ $<"
	g++ -fPIC $(CXXFLAGS) -c $< -o $@

$(COBJS): $(COBJDIR)/%.o: %.c
	@echo "compile $@ $<"
	gcc -fPIC $(CFLAGS) -c $< -o $@

$(CPPOBJDIR):
	@echo "compile $@ $<"
	@mkdir -p $(CPPOBJDIR)

$(COBJDIR):
	@ mkdir -p $(COBJDIR)

clean:
	$(RM) $(TARGET) $(OBJ)
	$(RM) -rf $(CPPOBJDIR)
	$(RM) -rf $(COBJDIR)
