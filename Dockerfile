FROM fundocker/edxapp:ginkgo.1-dev

# Dependencies
ENV DOCKERIZE_VERSION v0.6.0

# Get container user and group ids via build arguments
# Default: 0:0 (root:root)
ARG user=0
ARG group=0

# Add a non-privileged user to run the application
RUN groupadd --gid $group app && \
    useradd --uid $user --gid $group --home /app --create-home app

# Install dockerize
RUN curl -L \
         --output dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
         https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install project requirements
ADD ./requirements /app/fonzie/requirements
RUN pip install -q --exists-action w \
        -r /app/fonzie/requirements/dev.txt \
        -r /app/fonzie/requirements/private.*

# Add application sources
ADD . /app/fonzie/

# Install django application in development mode
RUN cd /app/fonzie && \
    pip install -e .

# FIXME: pyopenssl seems to be linked with a wrong openssl release leading to
# bad handskake ssl errors. This looks ugly, but forcing pyopenssl
# re-installation solves this issue.
RUN pip install -U pyopenssl

# Run container with the $user:$group user
#
# We recommand to build the container with the following build arguments to map container user
# with the HOST user:
# docker build --build-arg user=$(id -u) --build-arg group=$(id -g)
USER $user:$group