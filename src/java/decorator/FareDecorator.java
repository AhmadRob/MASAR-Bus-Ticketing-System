package decorator;


import strategy.FareStrategy;

// Base decorator
public abstract class FareDecorator implements FareStrategy {

    protected final FareStrategy decoratedStrategy;

    public FareDecorator(FareStrategy decoratedStrategy) {
        this.decoratedStrategy = decoratedStrategy;
    }
}
