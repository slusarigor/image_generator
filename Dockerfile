FROM ruby:3.0.2-alpine

ARG VIPS_VERSION=8.11.3
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN apk update && apk upgrade

# basic packages libvips likes
RUN apk add \
	build-base \
	autoconf \
	automake \
	libtool \
	bc \
	zlib-dev \
	expat-dev \
	jpeg-dev \
	tiff-dev \
	glib-dev \
	libjpeg-turbo-dev \
	libexif-dev \
	lcms2-dev \
	fftw-dev \
	giflib-dev \
	libpng-dev \
	libwebp-dev \
	orc-dev \
	libgsf-dev

# text rendering ... we have to download some fonts and rebuild the font
# cache
RUN apk add \
	pango-dev \
	msttcorefonts-installer
RUN update-ms-fonts \
	&& fc-cache -f

# add these for PDF rendering and SVG rendering, but they will pull in
# loads of other stuff
RUN apk add \
	poppler-dev \
	librsvg-dev

# there are other optional deps you can add for openslide / openexr /
# imagmagick support / Matlab support etc etc

# installing to /usr is not the best idea, but it's easy
RUN wget -O- ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | tar xzC /tmp
RUN cd /tmp/vips-${VIPS_VERSION} \
	&& ./configure --prefix=/usr --disable-static --disable-debug \
	&& make V=0 \
	&& make install

RUN apk add \
	ruby-dev \
	ruby-full
RUN gem install rdoc \
	ruby-vips
RUN gem install bundler

WORKDIR /code
COPY . /code
RUN bundle install

EXPOSE 4567

CMD ["/bin/bash"]
