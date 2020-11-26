FROM platform-automation-image:5.0.9

ADD ./scripts /scripts

ARG iaas_to_remove
ENV IAAS_TO_REMOVE=$iaas_to_remove

RUN /scripts/run-inside-container.sh \
    && rm -rf /scripts