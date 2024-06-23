FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y git vim

RUN mkdir -p /home/belle2 
ENV HOME /home/belle2

# Starting directory
WORKDIR $HOME

# Get basf2 tools
RUN git clone https://github.com/belle2/tools.git 

# Get basf2 externals
RUN mkdir -p $HOME/externals
WORKDIR $HOME/externals
RUN git clone https://github.com/belle2/externals.git

# Install everything
WORKDIR $HOME

# Install basf2 tools
RUN $HOME/tools/b2install-prepare --non-interactive --optionals

CMD ["/bin/bash"]
