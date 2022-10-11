
double rangeConverterDouble(double inputMin, double inputMax, double outputMin,
        double outputMax, double value) =>
    ((value - inputMin * (outputMax - outputMin)) / (inputMax - inputMin)) +
    outputMin;

