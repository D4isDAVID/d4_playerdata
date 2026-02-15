/** biome-ignore-all lint/style/useNamingConvention: this is how cfx declares functions */

declare interface Window {
    GetParentResourceName(): string;
}

declare module '*.css' {
    const classes: { [className: string]: string };
    export default classes;
}
