import sys

if __name__ == "__main__":
    if sys.argv[1][-4:] != '.wav':
        exit()
        
    audio_path = sys.argv[1]