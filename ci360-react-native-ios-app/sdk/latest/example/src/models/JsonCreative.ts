class JsonCreative {
  title: string;
  subTitle: string;
  bullets: string[];
  buttonText: string;

  constructor(json: string | null) {
    try {
      const data = JSON.parse(json);
      if (!data) {
        this.title = '';
        this.subTitle = '';
        this.bullets = [];
        this.buttonText = '';
      } else {
        this.title = data.title;
        this.subTitle = data.subTitle;
        this.bullets = data.bullets || [];
        this.buttonText = data.buttonText;
      }
    } catch (error) {
      console.log('JSON parse error: ', error);
      this.title = '';
      this.subTitle = '';
      this.bullets = [];
      this.buttonText = '';
    }
  }
}

export default JsonCreative;
