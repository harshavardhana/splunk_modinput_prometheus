all: prometheus prometheusrw

.PHONY: prometheus prometheusrw

prometheusrw:
	@echo "Building modinput_prometheus/linux_x86_64/bin/prometheusrw"
	@CGO_ENABLED=0 go build --ldflags "-s -w" -o modinput_prometheus/linux_x86_64/bin/prometheusrw ./prometheusrw/prometheusrw.go

prometheus:
	@echo "Building modinput_prometheus/linux_x86_64/bin/prometheus"
	@CGO_ENABLED=0 go build --ldflags "-s -w" -o modinput_prometheus/linux_x86_64/bin/prometheus ./prometheus/prometheus.go

package: prometheus prometheusrw
	@tar cvfz modinput_prometheus.tar.gz modinput_prometheus

# To use the validate target, install a Python venv in this directory, and install splunk-appinspect within it
# http://dev.splunk.com/view/appinspect/SP-CAAAFAW#installinvirtualenv
validate: package
	@bash -c 'source venv/bin/activate && splunk-appinspect inspect ./modinput_prometheus.tar.gz'

clean:
	@rm -vf modinput_prometheus/linux_x86_64/bin/prometheusrw
	@rm -vf modinput_prometheus/linux_x86_64/bin/prometheus
	@rm -vf *.tar.gz
