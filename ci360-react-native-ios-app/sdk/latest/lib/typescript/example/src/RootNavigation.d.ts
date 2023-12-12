export type RootTabParameterList = {
    Login: {
        diagnosticLink: string;
    };
    Details: {
        userId: string;
    };
    Home: {};
    Views: {};
    Messages: {};
    Diagnostics: {};
};
export declare const navigationRef: any;
export declare function navigate(name: string, params: any): void;
