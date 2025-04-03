import React, { createContext, useState, ReactNode } from 'react';

interface UserContextType {
  isLoggedIn: boolean;
  setIsLoggedIn: (isLoggedIn: boolean) => void;
  email: string;
  setEmail: (email: string) => void;
}

interface UserProviderProps {
  children: ReactNode; // Explicitly define children prop
}

export const UserContext = createContext<UserContextType | null>(null);

export const UserProvider: React.FC<UserProviderProps> = ({ children }) => {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [email, setEmail] = useState('');

  return (
    <UserContext.Provider value={{ isLoggedIn, setIsLoggedIn, email, setEmail }}>
      {children}
    </UserContext.Provider>
  );
};
