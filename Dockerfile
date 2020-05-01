FROM openjdk:15-jdk-buster

LABEL maintainer="David Liedle <david.liedle@protonmail.com>"
LABEL me.davidcanhelp.vendor="https://DavidCanHelp.me/"
LABEL me.davidcanhelp.twitter="@DavidCanHelp"
LABEL me.davidcanhelp.keybase="https://keybase.io/DavidCanHelp"
LABEL version="0.1.0"

RUN set -x                                                  \
    && apt-get update                                       \
    && apt-get full-upgrade -y -q                           \
    && apt-get install -y emacs-nox curl wget git zsh unzip \
    && apt-get autoremove -y -q                             \
    && apt-get autoclean



RUN useradd -d /home/student -ms /usr/bin/zsh student
USER student

# https://ohmyz.sh/#install
COPY --chown=student:student              \
     ./scripts/install-oh-my-z.sh         \
     /home/student/bin/install-oh-my-z.sh

# https://leiningen.org/
COPY --chown=student:student ./scripts/lein.sh /home/student/bin/lein


################################################################################
# Root stuff:
#

USER root

RUN set -x                                   \
    && chmod +x /home/student/bin/*          \
    && echo 'Why, hello there!' >> /etc/motd

################################################################################


USER student

# Execute the installations:
RUN /bin/bash /home/student/bin/install-oh-my-z.sh --unattended
RUN /bin/bash /home/student/bin/lein

WORKDIR /home/student

RUN set -x                                                                  \
    && echo 'export SHELL="/usr/bin/zsh"' >> /home/student/.myenv           \
    && echo 'export PATH="/home/student/bin:$PATH"' >> /home/student/.myenv \
    && echo 'source /home/student/.myenv' >> /home/student/.zshrc


#SHELL ["/usr/bin/zsh", "--login"]

ENTRYPOINT ["/usr/bin/zsh", "--login"]

# TODO:
# Pull https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
# instead of using a file
#
#RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
