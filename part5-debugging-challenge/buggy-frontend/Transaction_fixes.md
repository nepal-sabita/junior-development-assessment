# Bug Fix Summary

## Bug [1]: Memory leak fixes

1. State was set even if the component was not mounted
2. isMounted = true was set so to avoid setting state if unmounted

## Bug[2] : Refresh interval dependency array

1. refreshInterval was not in dependency array which amde the interval to eb ignored

2. refreshInterval was added to dependency array

## Bug[3]: Missing cleanup

1. clearInterval(interval) cleanup was not used which may later cause memory leaks
2. Added a cleanup function clearInterval(interval)

## Bug[4]: Creating new NumberFormat instance on every render (performance)

1. new Intl.NumberFormat() was created inside a render loop whoch causes a performance issue making the app slow and crash
2. useMemo is used to solve the issue as it helps to initialixe the date only once solving the rerender issues.

## Bug [5]: No error and loading handling
 1. There was no proper error and loading handler to show loading and errror UI

 2. Added loading and error message.
