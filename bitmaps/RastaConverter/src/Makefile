# vim:set tabstop=4:
# USE_ALLEGRO	= 0
.SUFFIXES:

.SUFFIXES: .cpp .o .o-pg .o-pu

SOURCES 	= CommandLineParser.cpp  config.cpp  main.cpp  rasta.cpp  rgb.cpp mt19937int.cpp

CXX			= g++

CXXFLAGS 	= -c -O3 -std=c++0x $(if $(USE_ALLEGRO),-DUSE_ALLEGRO) -I/opt/homebrew/include/
LDFLAGS 	= -L/opt/homebrew/lib 
LIBS		= -lfreeimage
LIBS		+= $(if $(USE_ALLEGRO),-lalleg -lX11 -lXcursor -lXpm -lXxf86vm -lpthread)
OBJECTS 	= $(SOURCES:.cpp=.o)

CXXFLAGSPG  = $(CXXFLAGS) -pg -fprofile-generate
LDFLAGSPG   = $(LDFLAGS) -pg
LIBSPG      = $(LIBS) -lgcov
OBJECTSPG 	= $(SOURCES:.cpp=.o-pg)
GCDA		= $(SOURCES:.cpp=.gcda)

CXXFLAGSPU  = $(CXXFLAGS) -fprofile-use
LDFLAGSPU   = $(LDFLAGS)
LIBSPU      = $(LIBS)
OBJECTSPU 	= $(SOURCES:.cpp=.o-pu)

EXECUTABLE	= rastaconv

all: $(EXECUTABLE)

pg: $(EXECUTABLE)-pg

pu: $(EXECUTABLE)-pu

$(EXECUTABLE): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $@ $(LIBS)

$(EXECUTABLE)-pg: $(OBJECTSPG)
	$(CXX) $(LDFLAGSPG) $(OBJECTSPG) -o $@ $(LIBSPG)

$(EXECUTABLE)-pu: $(OBJECTSPU)
	$(CXX) $(LDFLAGSPU) $(OBJECTSPU) -o $@ $(LIBSPU)

.cpp.o:
	$(CXX) $(CXXFLAGS) $< -o $@

.cpp.o-pg:
	$(CXX) $(CXXFLAGSPG) $< -o $@

.cpp.o-pu:
	$(CXX) $(CXXFLAGSPU) $< -o $@

$(OBJECTS): CommandLineParser.h  EpochTypes.h main.h rgb.h config.h ErrorConstants.h  rasta.h  string_conv.h

clean:
	rm -f *~ $(OBJECTS) $(OBJECTSPG) $(GCDA) $(OBJECTSPU) $(EXECUTABLE) $(EXECUTABLE)-pg $(EXECUTABLE)-pu
