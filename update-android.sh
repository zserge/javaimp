# get most recent android.jar
androidjar=$(find $ANDROID_HOME/platforms -name "android.jar" | sort | tail -n 1)

# write all android classes
jar tf $androidjar > android.jmplst

jaraar() {
	# find all JAR libraries in SDK extras
	find $1 -name "*.jar" |
		xargs -n1 jar tf >> android.jmplst 
	# find all AAR libraries in SDK extras
	find $1 -name "*.aar" | while read aar ; do
		unzip -q -c $aar classes.jar | jar t
	done >> android.jmplst
}

jaraar $ANDROID_HOME/extras
jaraar $HOME/.gradle/caches/modules-2

cat android.jmplst | grep "\.class$" | sort | uniq > android.jmplst.tmp
mv android.jmplst.tmp android.jmplst
