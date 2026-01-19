FROM ghcr.io/graalvm/graalvm-community:25

WORKDIR /app

COPY . .

# Convert gradlew to LF if it's currently CRLF (otherwise linux fails with "./gradlew: not found" error)
RUN if grep -q $'\r' gradlew; then \
        sed -i 's/\r$//' gradlew; \
    fi \
    && echo "Converted gradlew from CRLF to LF" \

RUN chmod +x gradlew
RUN ./gradlew nativeCompile --no-daemon
RUN chmod +x build/native/nativeCompile/*

EXPOSE 8080

ENTRYPOINT ["./build/native/nativeCompile/demo"]
